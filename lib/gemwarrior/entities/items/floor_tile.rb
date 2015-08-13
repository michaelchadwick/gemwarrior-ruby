# lib/gemwarrior/entities/items/floor_tile.rb
# Item::FloorTile

require_relative '../item'

module Gemwarrior
  class FloorTile < Item
    # CONSTANTS
    MOVE_TEXT = '*** SHOOOOOM ***'

    def initialize
      self.name         = 'floor_tile'
      self.description  = 'One of the floor tiles, rough-hewn but immaculate, looks...off. Pressable, even.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end

    def use(player = nil)
      puts 'You slowly lower your foot onto the tile, and then gently depress it, through the floor. Your whole body begins to feel light, lifeless. You black out.'
      puts

      # stats
      player.movements_made += 1

      Animation::run(phrase: MOVE_TEXT)

      { type: 'move', data: 'Rock Piles' }
    end
  end
end
