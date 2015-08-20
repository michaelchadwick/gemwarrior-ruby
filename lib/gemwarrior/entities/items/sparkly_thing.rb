# lib/gemwarrior/entities/items/sparklything.rb
# Item::SparklyThing

require_relative '../item'

module Gemwarrior
  class SparklyThing < Item
    def initialize
      super

      self.name         = 'sparkly_thing'
      self.description  = 'The sparkling that this thing does is unimaginably brilliant.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.equippable   = false
    end

    def use(player = nil)
      puts 'Everything, and I mean *everything*, begins to sparkle. Huh.'
      puts
      { type: nil, data: nil }
    end
  end
end
