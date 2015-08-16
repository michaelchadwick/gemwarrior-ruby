# lib/gemwarrior/entities/items/stone.rb
# Item::Stone

require_relative '../item'

module Gemwarrior
  class Stone < Item
    def initialize
      super

      self.name         = 'stone'
      self.description  = 'A small, sharp mega pebble, suitable for tossing in amusement, and perhaps combat.'
      self.atk_lo       = 1
      self.atk_hi       = 2
      self.takeable     = true
      self.useable      = true
      self.equippable   = true
    end
    
    def use(player = nil)
      puts 'You toss the stone a few feet into the air, and then it falls back into your palm. The experience was truly thrilling.'
      { type: nil, data: nil }
    end
  end
end
