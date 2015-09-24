# lib/gemwarrior/entities/weapons/spear.rb
# Entity::Item::Weapon::Spear

require_relative '../weapon'

module Gemwarrior
  class Spear < Weapon
    def initialize
      super

      self.name         = 'spear'
      self.name_display = 'Spear'
      self.description  = 'About six feet in length and razor-sharp at the point, this spear requires two hands, but only one good stab.'
      self.atk_lo       = 3
      self.atk_hi       = 7
      self.dex_mod      = -1
    end

    def use(world)
      puts 'This spear does, indeed, appear to strike fear upon that which is near.'
      { type: nil, data: nil }
    end
  end
end
