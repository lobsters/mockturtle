require 'open-uri'
require 'pstore'

require 'rss'
require 'summer'
require 'timers'

require 'lobstersbot/version'
require 'lobstersbot/rss_reader'
require 'lobstersbot/pluggable_connection'

require 'lobstersbot/plugins/tell'
require 'lobstersbot/plugins/rss'
require 'lobstersbot/plugins/salute'
require 'lobstersbot/plugins/title'

module Lobstersbot
  class Error < StandardError; end
  # Your code goes here...
end
