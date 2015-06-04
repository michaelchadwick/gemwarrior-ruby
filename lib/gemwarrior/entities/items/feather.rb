# lib/gemwarrior/entities/items/feather.rb
# Item::Feather

require_relative '../item'

module Gemwarrior
  class Feather < Item
    def initialize
      self.name         = 'feather'
      self.description  = 'A blue and green feather. It is soft and tender, unlike the craven bird that probably shed it.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end
  end
end
