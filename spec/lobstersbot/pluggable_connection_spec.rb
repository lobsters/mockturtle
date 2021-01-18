require 'spec_helper'
require 'tmpdir'

RSpec.describe Lobstersbot::PluggableConnection do
  subject { klass.new }

  let(:klass) do
    Class.new do
      include Lobstersbot::PluggableConnection
    end
  end
  let(:tmp_pstore_name) { Dir::Tmpname.create(['test', '.pstore']) {} }
  let(:pstore) { PStore.new(tmp_pstore_name, true) }

  before(:each) { subject.instance_variable_set(:@memory, pstore) }

  describe '#evaluate' do
    it 'invokes methods matching the given prefix' do
      klass.define_method(:frequently_do_an_action) do |memory|
        memory[:was_invoked] = true
      end

      subject.evaluate(:frequently)

      pstore.transaction do
        expect(pstore[:do_an_action][:was_invoked]).to be(true)
      end
    end
  end

  describe '#channel_message' do
    it 'invokes a on method when it sees a command' do
      privmsg = double

      klass.define_method(:privmsg) do |msg, to|
        privmsg.call(msg, to)
      end

      klass.define_method(:on_command) do |_memory, nick, message, response|
        response.call("#{nick} #{message}")
      end

      expect(privmsg).to receive(:call).with('Sample: Sample sample', 'sample')
      subject.channel_message({ nick: 'Sample' }, 'sample', '.command sample')
    end
  end

  describe '#join_event' do
    it 'invokes a seen method when it sees a join' do
      privmsg = double

      klass.define_method(:privmsg) do |msg, to|
        privmsg.call(msg, to)
      end

      klass.define_method(:seen_command) do |_memory, nick, response|
        response.call(nick)
      end

      expect(privmsg).to receive(:call).with('Sample: Sample', 'sample')
      subject.join_event({ nick: 'Sample' }, 'sample')
    end
  end
end
