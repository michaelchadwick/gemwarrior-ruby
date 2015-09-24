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
      self.dex_mod      = -1
    end

    def use(world)
      puts 'You wave the stalactite around in the air a bit, testing its weight and precision. It is a thin, long piece of rock taken from a cave wall, for sure, though.'
      { type: nil, data: nil }
    end
  end
end
