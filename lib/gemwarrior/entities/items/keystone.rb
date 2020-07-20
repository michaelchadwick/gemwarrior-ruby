# lib/gemwarrior/entities/items/keystone.rb
# Entity::Item::Keystone

require_relative '../item'

module Gemwarrior
  class Keystone < Item
    def initialize
      super

      self.name         = 'keystone'
      self.name_display = 'Keystone'
      self.description  = 'Certainly greater than the sum of its parts, this smallish stone glows faintly and feels slick to the touch.'
      self.takeable     = true
    end

    def use(world)
      puts 'The keystone glows a bit brighter when you grasp it tightly.'
      { type: nil, data: nil }
    end
  end
end
