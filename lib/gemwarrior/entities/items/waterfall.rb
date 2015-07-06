# lib/gemwarrior/entities/items/waterfall.rb
# Item::Waterfall

require_relative '../item'

module Gemwarrior
  class Waterfall < Item
    def initialize
      self.name         = 'waterfall'
      self.description  = 'Gallons of murky, sparkling water fall downward from an unknown spot in the sky, ending in a pool on the ground, yet never overflowing.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end

    def use(_player = nil)
      puts 'You stretch out your hand and touch the waterfall. It stings you with its cold and forceful gushing. Your hand is now wet and rougher than before. In time, it will dry.'
      { type: 'dmg', data: rand(0..1) }
    end
  end
end
