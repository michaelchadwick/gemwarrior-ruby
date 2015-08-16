# lib/gemwarrior/entities/items/dehumidifier.rb
# Item::Dehumidifier

require_relative '../item'

module Gemwarrior
  class Dehumidifier < Item
    def initialize
      super

      self.name         = 'dehumidifier'
      self.description  = 'Petals the color of clear sky and a stem of bright white. A most curious plant.'
      self.atk_lo       = 2
      self.atk_hi       = 4
      self.takeable     = true
      self.useable      = false
      self.equippable   = true
    end
  end
end
