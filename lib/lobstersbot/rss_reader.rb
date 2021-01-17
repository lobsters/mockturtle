require 'open-uri'
require 'rss'

module Lobstersbot
  class RssReader
    FORMAT = '%s %s (%s) - %s'
    USERNAME_REGXP = /\((?<username>.+)\)/i
    
    def initialize(endpoint, open_proc = URI.method(:open))
      @endpoint = endpoint
      @open = open_proc
    end
    
    def call(not_before)
      feed = @open.call(@endpoint)
      rss =  RSS::Parser.parse(feed)
      
      rss.items.map do |item|
        item.pubDate.to_i > not_before ? format_item(item) : nil
      end.compact
    end
    
    private 
    
    def format_item(item)
      id = item.guid.content
      categories = item.categories.map(&:content).map { |n| "[%s]" % n}
      username = item.author.match(USERNAME_REGXP)[:username]
      
      FORMAT % [item.title, categories.join(' '), username, id]
    end
  end
end