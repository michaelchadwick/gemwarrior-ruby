# lib/gemwarrior/entities/items/dehumidifier.rb
# Entity::Item::Dehumidifier

require_relative '../item'

module Gemwarrior
  class Dehumidifier < Item
    def initialize
      super

      self.name         = 'dehumidifier'
      self.name_display = 'Dehumidifier'
      self.description  = 'Humidity stands approximately zero chance when its presence.'
      self.takeable     = true
    end
  end
end
