# lib/gemwarrior/entities/items/sparklything.rb
# Item::SparklyThing

require_relative '../item'

module Gemwarrior
  class SparklyThing < Item
    def initialize
      self.name         = 'SparklyThing(tm)'
      self.description  = 'The sparkling that this thing does is unimaginably brilliant.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end
  end
end
