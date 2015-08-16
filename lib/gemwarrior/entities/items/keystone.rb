# lib/gemwarrior/entities/items/keystone.rb
# Item::Keystone

require_relative '../item'

module Gemwarrior
  class Keystone < Item
    def initialize
      super

      self.name         = 'keystone'
      self.description  = 'Certainly greater than the sum of its parts, this smallish stone glows faintly and feels slick to the touch.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = false
      self.equippable   = false
    end
  end
end
