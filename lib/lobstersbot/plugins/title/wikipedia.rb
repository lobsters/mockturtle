require 'wikipedia'

module Lobstersbot
  module Title
    class WikipediaHandler
      REGEXP = /wikipedia\.org\/wiki\/(?<article>[^#]+)(?:#(?<section>.+))?/i.freeze
      LENGTH = 250

      def get_summary(page, match)
        # Return from the article start if no section was specified.
        regular_summary = page.text[0..LENGTH-1].gsub "\n", " "
        return regular_summary unless match[:section]

        # Find the section
        section_name = match[:section].gsub "_", " "
        section_header = page.text.index(/=+\s*#{section_name}\s*=+\n/)
        return regular_summary unless section_header

        # Find the start of the text for the section.
        section_start = page.text.index("\n", section_header)
        return regular_summary unless section_header

        # Cut before the next section
        next_section = page.text.index("\n=", section_start)
        if next_section
          length = [next_section - section_start, LENGTH].min
        else
          length = LENGTH
        end

        return page.text[(section_start+1)..(section_start+length)].gsub "\n", " "
      end

      def handle(match)
        page = Wikipedia.find(match[:article])
        return unless page

        summary = get_summary page, match
        title = match[:article]
        if match[:section] then title << "##{match[:section]}" end

        return "[WIKIPEDIA #{title}] #{summary.strip}#{summary.length >= LENGTH ? '...' : ''}"
      end
    end
  end
end
