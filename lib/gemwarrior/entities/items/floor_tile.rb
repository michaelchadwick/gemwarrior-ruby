# lib/gemwarrior/entities/items/floor_tile.rb
# Entity::Item::FloorTile

require_relative '../item'

module Gemwarrior
  class FloorTile < Item
    # CONSTANTS
    MOVE_TEXT = '** SHOOOOOM **'

    def initialize
      super

      self.name         = 'floor_tile'
      self.name_display = 'Floor Tile'
      self.description  = 'One of the floor tiles, rough-hewn but immaculate, looks...off. Pressable, even.'
    end

    def use(world)
      puts 'You slowly lower your foot onto the tile, and then gently depress it, through the floor. Your whole body begins to feel light, lifeless. You black out.'
      puts

      # stats
      world.player.movements_made += 1

      Animation.run(phrase: MOVE_TEXT)

      { type: 'move', data: 'Rock Piles' }
    end
  end
end
