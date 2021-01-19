require 'spec_helper'

RSpec.describe Lobstersbot::Salute do
  subject { klass.new }

  let(:klass) do
    Class.new do
      include Lobstersbot::PluggableConnection
      include Lobstersbot::Salute
    end
  end

  describe '#salute_user' do
    it 'salutes users' do
      privmsg = double

      klass.define_method(:privmsg) do |message, channel|
        privmsg.call(message, channel)
      end

      srand 1
      expect(privmsg).to receive(:call).with(
        '(v)_!_!_V', '#channel')
      subject.channel_message({ nick: 'source' }, '#channel', 'V.v.V')
    end
  end
end
