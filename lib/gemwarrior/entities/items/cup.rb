# lib/gemwarrior/entities/items/cup.rb
# Item::Cup

require_relative '../item'

module Gemwarrior
  class Cup < Item
    def initialize
      self.name         = 'cup'
      self.description  = 'A nice, stone mug, perfect for putting things into and then using to carry such things from place to place.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = false
      self.equippable   = false
      self.equipped     = false
    end
  end
end
