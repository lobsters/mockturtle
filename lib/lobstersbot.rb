require 'open-uri'
require 'pstore'

require 'rss'
require 'summer'
require 'timers'

require 'lobstersbot/version'
require 'lobstersbot/rss_reader'
require 'lobstersbot/summer_patches'
require 'lobstersbot/pluggable_connection'

require 'lobstersbot/plugins/tell'
require 'lobstersbot/plugins/rss'
require 'lobstersbot/plugins/salute'

module Lobstersbot
  class Error < StandardError; end
  # Your code goes here...
end
