# lib/gemwarrior/entities/items/dehumidifier.rb
# Entity::Item::Dehumidifier

require_relative '../item'

module Gemwarrior
  class Dehumidifier < Item
    def initialize
      super

      self.name         = 'dehumidifier'
      self.name_display = 'Dehumidifier'
      self.description  = 'Humidity stands approximately zero chance of surviving when in its presence.'
      self.takeable     = true
    end

    def use(world)
      puts 'Despite your figeting, the lack of humidity remains the same.'
      { type: nil, data: nil }
    end
  end
end
