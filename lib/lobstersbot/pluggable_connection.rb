module Lobstersbot
  module PluggableConnection
    def config_dir(file)
      File.join(ARGV[0], file)
    end

    def load_config
      @config = HashWithIndifferentAccess.new(YAML.load_file(config_dir('lobstersbot.yml')))
    end

    def did_start_up
      pp ARGV
      @timers = Timers::Group.new
      @memory = PStore.new(config_dir('memory.pstore'), true)

      @timers.every(60) { evaluate(:frequently) }
      Thread.new { loop { @timers.wait } }
    end

    def channel_message(sender, channel, message)
      request = message.match(/\A\.(?<command>[a-z]+)\s(?<message>.+)\z/i)
      return unless request
      response_proc = ->(msg) { privmsg("#{sender[:nick]}: #{msg}", channel) }

      evaluate(:"on_#{request[:command]}", sender[:nick], request[:message], response_proc)
    end

    def join_event(sender, channel)
      response_proc = ->(msg) { privmsg("#{sender[:nick]}: #{msg}", channel) }
      evaluate(:seen, sender[:nick], response_proc)
    end

    def evaluate(group, *args)
      matching = public_methods.select {|m| m.to_s.start_with?(group.to_s) }

      matching.each do |match|
        slice_name = match.to_s.sub("#{group}_", '').to_sym
        @memory.transaction do
          slice = @memory[slice_name] ||= {}
          method(match).call(slice, *args)
        end
      end
    end
  end
end
