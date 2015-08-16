# lib/gemwarrior/entities/items/dagger.rb
# Item::Dagger

require_relative '../item'

module Gemwarrior
  class Dagger < Item
    def initialize
      super

      self.name         = 'dagger'
      self.description  = 'Flint that has been sharpened to a point, attached to a block of smooth granite by thin rope. Truly a work of art.'
      self.atk_lo       = 1
      self.atk_hi       = 3
      self.takeable     = true
      self.useable      = false
      self.equippable   = true
    end
  end
end
