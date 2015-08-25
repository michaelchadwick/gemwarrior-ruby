# lib/gemwarrior/entities/items/ladder.rb
# Entity::Item::Ladder

require_relative '../item'

module Gemwarrior
  class Ladder < Item
    # CONSTANTS
    USE_TEXT = '** THUMP **'

    def initialize
      super

      self.name         = 'ladder'
      self.name_display = 'Ladder'
      self.description  = 'Rickety and crudely-fashioned, this ladder descends down into the dropoff, hopefully heading towards something...anything.'
    end

    def use(world)
      puts 'You grab onto the shaky, rough-hewn, wooden ladder with all your might and start to descend, being extra careful not to loose your grip, which with every moment becomes shakier and shakier.'
      puts

      # stats
      world.player.movements_made += 1

      Animation.run(phrase: USE_TEXT)

      puts 'The last couple of steps are more slippery than you anticipated, so you end up fumbling them, falling a few feet onto the hard ground below. When you regain your composure, you notice your conveyance for descending is now far above you and it is, unfortunately, your closest known exit.'
      puts

      { type: 'move_dangerous', data: 'metal_tunnel-south_entrance' }
    end
  end
end
