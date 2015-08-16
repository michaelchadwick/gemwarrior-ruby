# lib/gemwarrior/entities/items/flower.rb
# Item::Flower

require_relative '../item'

module Gemwarrior
  class Flower < Item
    def initialize
      super

      self.name         = 'flower'
      self.description  = 'Petals the color of clear sky and a stem of bright white. A most curious plant.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = false
      self.equippable   = false
    end
  end
end
