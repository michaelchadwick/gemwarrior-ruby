# lib/gemwarrior/entities/items/sand_jewel.rb
# Entity::Item::SandJewel

require_relative '../item'

module Gemwarrior
  class SandJewel < Item
    def initialize
      super

      self.name         = 'sand_jewel'
      self.name_display = 'Sand Jewel'
      self.description  = 'As blue (or is it violet? or brown?) as it is brittle, this shiny rock feels warm to the touch.'
    end

    def use(world)
      puts 'You lift the sand jewel to the sky; rays of sunlight refract through it and nearly blind you.'
      { type: nil, data: nil }
    end
  end
end
