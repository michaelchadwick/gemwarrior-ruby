# lib/gemwarrior/entities/items/spear.rb
# Item::Spear

require_relative '../item'

module Gemwarrior
  class Spear < Item
    def initialize
      super

      self.name         = 'spear'
      self.description  = 'Sharp spikes atop a steel ball, affixed to a sturdy wooden handle. You could do damage with this.'
      self.atk_lo       = 3
      self.atk_hi       = 7
      self.takeable     = true
      self.useable      = true
      self.consumable   = false
      self.equippable   = true
    end
    
    def use(player = nil)
      puts 'This spear does, indeed, appear to strike fear upon that which is near.'
      { type: nil, data: nil }
    end
  end
end
