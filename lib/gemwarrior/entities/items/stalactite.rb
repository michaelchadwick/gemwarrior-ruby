# lib/gemwarrior/entities/items/stalactite.rb
# Item::Stalactite

require_relative '../item'

module Gemwarrior
  class Stalactite < Item
    def initialize
      self.name         = 'stalactite'
      self.description  = 'Long protrusion of cave adornment, broken off and fallen to the ground, where the stalagmites sneer at it from.'
      self.atk_lo       = 2
      self.atk_hi       = 3
      self.takeable     = true
      self.useable      = true
      self.equippable   = true
      self.equipped     = false
    end
  end
end
