# lib/gemwarrior/entities/weapons/stalactite.rb
# Entity::Item::Weapon::Stalactite

require_relative '../weapon'

module Gemwarrior
  class Stalactite < Weapon
    def initialize
      super

      self.name         = 'stalactite'
      self.name_display = 'Stalactite'
      self.description  = 'Long protrusion of cave adornment, broken off and fallen to the ground, where the stalagmites sneer at it from.'
      self.atk_lo       = 2
      self.atk_hi       = 3
    end
  end
end
