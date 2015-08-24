# lib/gemwarrior/entities/items/apple.rb
# Entity::Item::Apple

require_relative '../item'

module Gemwarrior
  class Apple < Item
    def initialize
      super

      self.name         = 'apple'
      self.name_display = 'Apple'
      self.description  = 'Reddish-orangeish in color, this fruit looks sweet, but it is heavy and feels more like a rock you would sooner not bite into.'
      self.takeable     = true
    end
  end
end
