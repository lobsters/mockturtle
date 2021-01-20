require 'net/http'

require 'lobstersbot/plugins/title/wikipedia'
require 'lobstersbot/plugins/title/lobsters'

StopIteration = Class.new(StandardError)

def parse_title(response)
  nread = 0
  title = nil

  response.read_body do |chunk|
    raise StopIteration if nread > 16_384

    title = chunk[/<title>([^<]+)<\/title>/im, 1]&.strip
    raise StopIteration if title

    nread += chunk.length
  end
rescue StopIteration
  title
end

def fetch(uri, limit = 10, &block)
  # Avoid redirect loops
  return unless limit > 0

  request = Net::HTTP::Get.new uri
  Net::HTTP.start(uri.host, uri.port, use_ssl: (uri.scheme == 'https'),
                  open_timeout: 5, read_timeout: 5) do |http|
    http.request(request) do |response|
      case response
      when Net::HTTPSuccess then return block.call(response)
      when Net::HTTPRedirection then return fetch(URI(response['location']), limit - 1, &block)
      end
    end
  end
end

module Lobstersbot
  module Title
    HANDLERS = [
      WikipediaHandler.new,
      LobstersHandler.new,
    ].freeze

    def get_title(channel, message)
      uri = message[0]

      # Find whether we can display special information for this title.
      match = nil
      handler = HANDLERS.find do |h|
        match = uri.match(h.class::REGEXP)
        !match.nil?
      end

      if handler.nil?
        # Just a simple title grab.
        uri = URI(uri)
        title = fetch(uri) {|response| parse_title(response) }
        unless title.nil?
          privmsg("[ #{title} ] - #{uri.host}", channel)
        end
      else
        # Special title data.
        response = handler.handle(match)
        privmsg(response, channel)
      end
    end

    def self.included(mod)
      handle = ->(bot, channel, _nick, message) { bot.get_title(channel, message) }
      mod.add_trigger(10, URI::DEFAULT_PARSER.make_regexp, handle)
    end
  end
end
