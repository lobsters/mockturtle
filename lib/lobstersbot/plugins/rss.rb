module Lobstersbot
  module Rss
    def frequently_post_stories(
      memory,
      reader = RssReader.new('https://lobste.rs/newest.rss')
    )
      last_run = memory[:last_run] || 0
      stories = reader.call(last_run)

      if stories.length > 5
        @config[:channels].each do |channel|
          privmsg("Skipping #{stories.length} postings for anti-flood (Last Run: #{last_run}).",
                  channel)
        end
      else
        stories.each do |story|
          @config[:channels].each do |channel|
            privmsg(story, channel)
            sleep 1
          end
        end
      end

      memory[:last_run] = Time.now.to_i
    end
  end
end
