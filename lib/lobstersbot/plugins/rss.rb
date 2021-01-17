module Lobstersbot
  module Rss
    def frequently_post_stories(
      memory, 
      reader = RssReader.new('https://lobste.rs/newest.rss')
    )
      reader.call(memory[:last_run]).each do |story|
        @config[:channels].each { |c| privmsg(story, c) }
      end
      memory[:last_run] = Time.now.to_i
    end
  end
end