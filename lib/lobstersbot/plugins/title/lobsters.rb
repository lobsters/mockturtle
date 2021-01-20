require 'uri'
require 'json'

module Lobstersbot
  module Title
    class LobstersHandler
      REGEXP = /lobste\.rs\/s\/(?<story>[^\/#]+)(?:.*#c_(?<comment>.*))?/i.freeze
      LIMIT = 250

      def strip_html(s)
        # https://gist.github.com/awesome/225181
        s.gsub(/<\/?[^>]*>/, "").gsub("\n", " ")
      end

      def plural(n)
        n == 1 ? "" : "s"
      end

      def handle(match)
        raw_data = fetch(URI("https://lobste.rs/s/#{match[:story]}.json"), &:body)
        story = JSON.parse raw_data

        if match[:comment]
          comment = story['comments'].find {|c| c['short_id'] == match[:comment] }
          unless comment.nil?
            body = strip_html(comment['comment'])[0..LIMIT-1]
            return "[Comment on https://lobste.rs/s/#{match[:story]}/] " +
                   "#{body.strip}#{body.length == LIMIT ? '...' : ''}"
          end
        end

        title = story['title']
        submitter = story['submitter_user']['username']
        score = story['score']
        comments = story['comment_count']

        return "[Story] #{title} (via #{submitter}, #{score} point#{plural(score)}, " +
               "#{comments} comment#{plural(comments)})"
      end
    end
  end
end
