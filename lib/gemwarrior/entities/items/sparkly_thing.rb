# lib/gemwarrior/entities/items/sparklything.rb
# Entity::Item::SparklyThing

require_relative '../item'

module Gemwarrior
  class SparklyThing < Item
    def initialize
      super

      self.name         = 'sparkly_thing'
      self.name_display = 'SparklyThing(tm)'
      self.description  = 'The sparkling that this thing does is unimaginably brilliant.'
      self.takeable     = true
    end

    def use(world)
      puts 'Everything, and I mean *everything*, begins to sparkle. Huh.'
      { type: nil, data: nil }
    end
  end
end
