'use strict'

const IRC = require('irc-framework')
const level = require('level')
const got = require('got')
const metascraper = require('metascraper')([
  require('metascraper-title')()
])

const logger = require('./logger.js')
const commands = require('./commands.js')
const scheduled = require('./scheduled.js')

const config = new URL(process.argv.pop())
const client = new IRC.Client()
const storage = level('storage.leveldb')

const maxTitleSize = 200

const timers = {}

const truncate = (inputStr, len) => {
  let shortenedStr = ''
  shortenedStr = inputStr.slice(0, len)
  if (shortenedStr.length < inputStr.length) {
    shortenedStr += '…'
  }
  return shortenedStr
}

const fetchTitle = async (targetUrl) => {
  const { body: html, url } = await got(targetUrl)
  const { title } = await metascraper({ html, url })
  return truncate(title, maxTitleSize)
}

const injectLoggerMiddleware = (baseLogger) => {
  const middleware = (command, event, client, next) => {
    event.logger = baseLogger.child({
      defaultMeta: {
        account: event.account,
        message: event.message,
        target: event.target
      }
    })
    next()
  }

  return (_client, _rawEvents, parsedEvents) => {
    parsedEvents.use(middleware)
  }
}

const injectValue = (key, value) => {
  const middleware = (command, event, client, next) => {
    event[key] = value
    next()
  }

  return (_client, _rawEvents, parsedEvents) => {
    parsedEvents.use(middleware)
  }
}

client.use(injectLoggerMiddleware(logger))
client.use(injectValue('database', storage))
client.use(injectValue('fetchTitle', fetchTitle))

commands.forEach(command => client.matchMessage(command.__match__, command))

client.on('debug', event => logger.debug('Debug Event', { event }))

client.on('registered', (event) => {
  const channels = config.hash.split(',')
  event.logger.info('Joining requested channels.', { channels })
  channels
    .map(channelName => client.channel(channelName))
    .forEach(channel => channel.join())
})

client.on('join', (event) => {
  event.logger.info('Activating scheduled tasks.')
  event.reply = (message) => client.channel(event.channel).say(message)

  if (timers[event.channel] === undefined) {
    timers[event.channel] = scheduled.map(fn => setInterval(fn, fn.__interval__, event))
  }
})

client.on('leave', (event) => {
  event.logger.info('Deactivating scheduled tasks.')
  timers[event.channel].map(timer => clearImmediate(timer))
})

client.connect({
  host: config.hostname,
  ssl: true,
  port: config.port,
  nick: config.username,
  account: {
    account: config.username,
    password: config.password
  }
})
