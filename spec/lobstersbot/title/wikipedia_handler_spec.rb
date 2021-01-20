require 'spec_helper'

RSpec.describe Lobstersbot::Title::WikipediaHandler do
  subject { Lobstersbot::Title::WikipediaHandler.new }

  describe '#handle' do
    it 'returns article summary' do
      result = subject.handle({ article: "Hacker_News" })
      # rubocop:disable Style/StringConcatenation
      expect(result).to eq(
        "[WIKIPEDIA Hacker_News] Hacker News is a social news website focusing "+
        "on computer science and entrepreneurship. It is run by Paul Graham's "+
        "investment fund and startup incubator, Y Combinator. In general, "+
        "content that can be submitted is defined as \"anything that "+
        "gratifies o...")
      # rubocop:enable Style/StringConcatenation
    end

    it 'returns section summary' do
      result = subject.handle({ article: "Hacker_News", section: "Vision_and_practices" })
      # rubocop:disable Style/StringConcatenation
      expect(result).to eq(
        "[WIKIPEDIA Hacker_News#Vision_and_practices] The intention was to recreate "+
        "a community similar to the early days of Reddit. However, unlike Reddit where "+
        "new users can immediately both upvote and downvote content, Hacker News does "+
        "not allow users to downvote content until they have accumulated 5...")
      # rubocop:enable Style/StringConcatenation
    end

    it 'avoids returning multiple sections' do
      result = subject.handle({ article: "Bubble_sort", section: "Pseudocode_implementation" })
      expect(result).to eq(
        "[WIKIPEDIA Bubble_sort#Pseudocode_implementation] In pseudocode the algorithm can " +
        "be expressed as (0-based array):")
    end
  end
end
