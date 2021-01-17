module Lobstersbot
  module Tell
    def on_tell(memory, nick, message, response)
      parsed = message.match(/(?<target>[^\s]+)\s(?<message>.+)/)
      return unless parsed
      
      target = parsed[:target]
      memory[target] ||= Array.new
      memory[target] << "#{nick}: #{parsed[:message]}"
      
      response.call("I'll pass that along when #{target} is around.")
    end
    
    def seen_tell(memory, nick, response)
      return unless memory[nick].is_a? Array
      memory[nick].each { |msg| response.call(msg) }
    end
  end
end