# lib/gemwarrior/entities/items/waterfall.rb
# Entity::Item::Waterfall

require_relative '../item'

module Gemwarrior
  class Waterfall < Item
    def initialize
      super

      self.name         = 'waterfall'
      self.name_display = 'Waterfall'
      self.description  = 'Gallons of murky, sparkling water fall downward from an unknown spot in the sky, ending in a pool on the ground, yet never overflowing.'
    end

    def use(player = nil)
      puts 'You stretch out your hand and touch the waterfall. It stings you with its cold and forceful gushing. Your hand is now wet and rougher than before. In time, it will dry.'
      
      dmg = rand(0..1)
      
      puts '>> You lose a hit point.'.colorize(:red) if dmg > 0
      
      { type: 'dmg', data: dmg }
    end
  end
end
