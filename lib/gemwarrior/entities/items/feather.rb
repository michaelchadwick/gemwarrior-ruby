# lib/gemwarrior/entities/items/feather.rb
# Entity::Item::Feather

require_relative '../item'

module Gemwarrior
  class Feather < Item
    def initialize
      super

      self.name         = 'feather'
      self.name_display = 'Feather'
      self.description  = 'A blue and green feather. It is soft and tender, unlike the craven bird that probably shed it.'
      self.takeable     = true
    end
  end
end
