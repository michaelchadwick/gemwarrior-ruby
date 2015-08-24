# lib/gemwarrior/entities/weapons/spear.rb
# Entity::Item::Weapon::Spear

require_relative '../weapon'

module Gemwarrior
  class Spear < Weapon
    def initialize
      super

      self.name         = 'spear'
      self.name_display = 'Spear'
      self.description  = 'Sharp spikes atop a steel ball, affixed to a sturdy wooden handle. You could do damage with this.'
      self.atk_lo       = 3
      self.atk_hi       = 7
    end

    def use(player = nil)
      puts 'This spear does, indeed, appear to strike fear upon that which is near.'
      { type: nil, data: nil }
    end
  end
end
