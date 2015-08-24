# lib/gemwarrior/entities/weapons/dagger.rb
# Entity::Item::Weapon::Dagger

require_relative '../weapon'

module Gemwarrior
  class Dagger < Weapon
    def initialize
      super

      self.name         = 'dagger'
      self.name_display = 'Dagger'
      self.description  = 'Flint that has been sharpened to a point, attached to a block of smooth granite by thin rope. Truly a work of art.'
      self.atk_lo       = 1
      self.atk_hi       = 3
    end
  end
end
