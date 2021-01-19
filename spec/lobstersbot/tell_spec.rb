require 'spec_helper'

RSpec.describe Lobstersbot::Tell do
  subject { klass.new }

  let(:klass) do
    Class.new do
      include Lobstersbot::Tell
    end
  end

  describe '#on_tell' do
    it 'logs messages' do
      memory = {}
      channel = '#channel'
      nick = 'source'

      respond = double

      klass.define_method(:respond) do |channel_, nick_, message_|
        respond.call(channel_, nick_, message_)
      end

      expect(respond).to receive(:call).with(
        channel, nick, "I'll pass that along when target is around.")
      subject.on_tell(memory, channel, nick, 'target message')
      expect(memory['target']).to contain_exactly('source: message')
    end
  end

  describe '#seen_tell' do
    it 'replays messages' do
      memory = { 'target' => ['message'] }
      response = double

      expect(response).to receive(:call).with('message')
      subject.seen_tell(memory, 'target', response)
    end
  end
end
