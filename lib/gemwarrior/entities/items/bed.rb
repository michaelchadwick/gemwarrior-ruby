# lib/gemwarrior/entities/items/bed.rb
# Item::Bed

require_relative '../item'

module Gemwarrior
  class Bed < Item
    def initialize
      self.name         = 'bed'
      self.description  = 'The place where you sleep when you are not adventuring.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end
  end
end
