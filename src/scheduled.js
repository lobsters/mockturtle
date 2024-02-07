'use strict'

const Parser = require('rss-parser')

const readGitHubRss = (event) => {
  const fun = async () => {
    const feeds = {
      lobsters: 'https://github.com/lobsters/lobsters/commits/master.atom',
      lobstersAnsible: 'https://github.com/lobsters/lobsters-ansible/commits/master.atom',
      mockturtle: 'https://github.com/lobsters/mockturtle/commits/master.atom'
    }

    for (const [repo, feed] of Object.entries(feeds)) {
      const key = `rss/commits/${repo}`
      const parser = new Parser()
      let lastSeen = new Date(0)

      try {
        const rawDate = await event.database.get(key)
        lastSeen = new Date(rawDate)
      } catch (e) {
        if (e.notFound) {
          // first run, save date rather than print all commits
          await event.database.put(key, (new Date()).toISOString())
          continue
        } else {
          event.logger.error(e)
        }
      }

      const newest = await parser.parseURL(feed)
      newest.items.reverse().forEach(item => {
        const publishedAt = new Date(item.isoDate)

        if (publishedAt > lastSeen) {
          lastSeen = publishedAt

          event.logger.info('Broadcasting story.', { itemDate: item.isoDate, itemGuid: item.guid, lastSeen })
          event.reply(`${repo} commit: ${item.title.trim()} (by ${item.author}) ${item.link}`)
        }
      })

      await event.database.put(key, lastSeen.toISOString())
    }
    return true
  }

  return fun()
}
readGitHubRss.__interval__ = 10 * 60 * 1000 // ms

const readLobstersRss = (event) => {
  const fun = async () => {
    const parser = new Parser()
    const newest = await parser.parseURL('https://lobste.rs/newest.rss')
    let lastSeen = new Date(0)

    try {
      const rawDate = await event.database.get('rss/lobsters')
      lastSeen = new Date(rawDate)
    } catch (e) {
      if (e.notFound) {
        // do nothing
      } else {
        event.logger.error(e)
      }
    }

    newest.items.reverse().forEach(item => {
      const { groups: { username } } = /\((?<username>.+)\)/i.exec(item.author)
      const publishedAt = new Date(item.isoDate)

      if (publishedAt > lastSeen) {
        lastSeen = publishedAt

        event.logger.info('Broadcasting story.', { itemDate: item.isoDate, itemGuid: item.guid, lastSeen })
        event.reply(`${item.title} [${item.categories.join(' ')}] (${username}) ${item.guid}`)
      }
    })

    await event.database.put('rss/lobsters', lastSeen.toISOString())
    return true
  }

  return fun()
}
readLobstersRss.__interval__ = 5000 // ms

module.exports = [
  readGitHubRss,
  readLobstersRss
]
