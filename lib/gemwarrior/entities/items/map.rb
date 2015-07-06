# lib/gemwarrior/entities/items/map.rb
# Item::Map

require_relative '../item'

module Gemwarrior
  class Map < Item
    def initialize
      self.name         = 'map'
      self.description  = 'The land of Jool is contained on this piece of canvas, in a useful, if not very detailed, manner.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end

    def use(_player = nil)
      puts 'You unfold the piece of worn canvas, and study the markings upon it.'

      { type: 'action', data: 'map' }
    end
  end
end
