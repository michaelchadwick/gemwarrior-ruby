# lib/gemwarrior/entities/items/tent.rb
# Entity::Item::Tent

require_relative '../item'

module Gemwarrior
  class Tent < Item
    def initialize
      super

      self.name           = 'tent'
      self.name_display   = 'Tent'
      self.description    = 'A magical, two-room suite pops up when you flick this otherwise folded piece of canvas just right, perfect for a night\'s rest.'
      self.takeable       = true
      self.number_of_uses = 5
    end

    def use(world)
      { type: 'tent', data: self.number_of_uses }
    end
  end
end
