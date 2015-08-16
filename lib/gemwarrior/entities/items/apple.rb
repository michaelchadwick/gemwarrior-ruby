# lib/gemwarrior/entities/items/apple.rb
# Item::Apple

require_relative '../item'

module Gemwarrior
  class Apple < Item
    def initialize
      super

      self.name         = 'apple'
      self.description  = 'Reddish-orangeish in color, this fruit looks sweet, but it is heavy and feels more like a rock you would sooner not bite into.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = false
      self.equippable   = false
    end
  end
end
