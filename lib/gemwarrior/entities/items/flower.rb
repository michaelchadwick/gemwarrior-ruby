# lib/gemwarrior/entities/items/flower.rb
# Item::Flower

require_relative '../item'

module Gemwarrior
  class Flower < Item
    def initialize
      super

      self.name         = 'flower'
      self.name_display = 'Flower'
      self.description  = 'Petals the color of clear sky and a stem of bright white. A most curious plant.'
      self.takeable     = true
    end
  end
end
