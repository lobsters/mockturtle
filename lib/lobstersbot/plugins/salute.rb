module Lobstersbot
  module Salute
    @@claws = ['(V)', '(\\/)', '(\\_/)', 'V', 'v', '(v)']
    @@faces = ['_!_!_', '.v.', '_00_']

    def salute_user(channel)
      claws = @@claws.sample 2
      face = @@faces.sample
      lobster = claws[0] + face + claws[1]
      privmsg(lobster, channel)
    end

    def self.included(mod)
      handler = ->(bot, channel, _nick, _match) { bot.salute_user channel }
      mod.add_trigger(100, /\AV.v.V\z/i, handler)
    end
  end
end
