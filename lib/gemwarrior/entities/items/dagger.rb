# lib/gemwarrior/entities/items/dagger.rb
# Item::Dagger

require_relative '../item'

module Gemwarrior
  class Dagger < Item
    def initialize
      self.name         = 'dagger'
      self.description  = 'Flint that has been sharpened to a point, attached to a block of smooth granite by thin rope. Truly a work of art.'
      self.atk_lo       = 2
      self.atk_hi       = 4
      self.takeable     = true
      self.useable      = false
      self.equippable   = true
      self.equipped     = false
    end
  end
end
