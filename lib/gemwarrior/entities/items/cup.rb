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

    def use(world)
      puts 'Nothing in the cup at the moment, so not very usable.'
      { type: nil, data: nil }
    end
  end
end
