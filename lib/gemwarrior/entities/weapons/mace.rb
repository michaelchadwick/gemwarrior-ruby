# lib/gemwarrior/entities/weapons/mace.rb
# Entity::Item::Weapon::Mace

require_relative '../weapon'

module Gemwarrior
  class Mace < Weapon
    def initialize
      super

      self.name         = 'mace'
      self.name_display = 'Mace'
      self.description  = 'Sharp spikes atop a steel ball, affixed to a sturdy wooden handle. You could do damage with this.'
      self.atk_lo       = 4
      self.atk_hi       = 6
      self.dex_mod      = -2
    end
    
    def use(world)
      puts 'You swing the mace around a few times, really testing out its smashability.'
      { type: nil, data: nil }
    end
  end
end
