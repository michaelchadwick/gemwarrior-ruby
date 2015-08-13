# lib/gemwarrior/game_options.rb
# Gem Warrior Global Game Options

module Gemwarrior
  module GameOptions
    def self.add key, value
      @@data ||= {}
      @@data[key] = value
    end

    def self.data
      @@data ||= {}
    end
  end
end
