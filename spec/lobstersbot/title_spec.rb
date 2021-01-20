require 'spec_helper'
require 'uri'

RSpec.describe Lobstersbot::Title do
  subject { klass.new }

  let(:klass) do
    Class.new do
      include Lobstersbot::PluggableConnection
      include Lobstersbot::Title
    end
  end

  describe '#fetch' do
    it 'fetches titles' do
      title = fetch(URI("https://lobste.rs/")) {|r| parse_title(r) }
      expect(title).to eq("Lobsters")
    end

    it 'avoids redirect loops' do
      title = fetch(
        URI("https://demo.cyotek.com/features/redirectlooptest.php")) {|r| parse_title(r) }
      expect(title).to be_nil
    end
  end

  # XXX: Should this be disabled? Apparently it's bad style
  # (https://github.com/rubocop-hq/rspec-style-guide#dont-stub-subject)
  # but I can't find a better way to expect messages on privmsg.
  # rubocop:disable RSpec/SubjectStub
  describe '#get_title' do
    it 'parses titles from messages' do
      expect(subject).to receive(:privmsg).with("[ Lobsters ] - lobste.rs", "#channel")
      subject.channel_message({ nick: "source" }, "#channel", "test https://lobste.rs/ test test")
    end

    it 'expects URL scheme' do
      expect(subject).not_to receive(:privmsg)
      subject.channel_message({ nick: "source" }, "#channel", "test lobste.rs test test")
    end

    it 'handles specialized URLs' do
      # rubocop will stretch the string and then complain about line length.
      # rubocop:disable Style/StringConcatenation
      excerpt = "[WIKIPEDIA Freenode] freenode, formerly known as Open Projects Network, " +
                "is an IRC network used to discuss peer-directed projects. Their servers " +
                "are accessible from the host names chat.freenode.net, which load balances " +
                "connections by using the actual servers in rotation...."
      # rubocop:enable Style/StringConcatenation
      expect(subject).to receive(:privmsg).with(excerpt, "#channel")
      subject.channel_message({ nick: "source" }, "#channel",
                              "test https://en.wikipedia.org/wiki/Freenode test")
    end
  end
  # rubocop:enable RSpec/SubjectStub
end
