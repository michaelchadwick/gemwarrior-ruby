# lib/gemwarrior/entities/items/cup.rb
# Entity::Item::Cup

require_relative '../item'

module Gemwarrior
  class Cup < Item
    def initialize
      super

      self.name         = 'cup'
      self.name_display = 'Cup'
      self.description  = 'A nice stone mug, perfect for putting things into and then using to carry such things from place to place.'
      self.takeable     = true
    end
  end
end
