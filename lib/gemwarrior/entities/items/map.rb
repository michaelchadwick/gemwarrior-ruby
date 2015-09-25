# lib/gemwarrior/entities/items/map.rb
# Entity::Item::Map

require_relative '../item'

module Gemwarrior
  class Map < Item
    def initialize
      super

      self.name         = 'map'
      self.name_display = 'Map'
      self.description  = 'The land of Jool is contained on this piece of canvas, in a useful, if not very detailed, manner.'
      self.takeable     = true
    end

    def use(world)
      puts 'You unfold the piece of worn canvas and study the markings upon it, always making sure to update it with new places you find.'

      { type: 'action', data: 'map' }
    end
  end
end
