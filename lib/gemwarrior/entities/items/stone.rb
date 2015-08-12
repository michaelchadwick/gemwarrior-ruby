# lib/gemwarrior/entities/items/stone.rb
# Item::Stone

require_relative '../item'

module Gemwarrior
  class Stone < Item
    def initialize
      self.name         = 'stone'
      self.description  = 'A small, sharp mega pebble, suitable for tossing in amusement, and perhaps combat.'
      self.atk_lo       = 1
      self.atk_hi       = 2
      self.takeable     = true
      self.useable      = false
      self.equippable   = true
      self.equipped     = false
    end
  end
end
