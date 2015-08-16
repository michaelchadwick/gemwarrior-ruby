# lib/gemwarrior/entities/items/mace.rb
# Item::Mace

require_relative '../item'

module Gemwarrior
  class Mace < Item
    def initialize
      super

      self.name         = 'mace'
      self.description  = 'Sharp spikes atop a steel ball, affixed to a sturdy wooden handle. You could do damage with this.'
      self.atk_lo       = 4
      self.atk_hi       = 6
      self.takeable     = true
      self.useable      = true
      self.consumable   = false
      self.equippable   = true
    end
    
    def use(player = nil)
      puts 'You swing the mace around a few times, really testing out its smashability.'
      { type: nil, data: nil }
    end
  end
end
