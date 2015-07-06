# lib/gemwarrior/entities/items/ladder.rb
# Item::Ladder

require_relative '../item'

module Gemwarrior
  class Ladder < Item
    def initialize
      self.name         = 'ladder'
      self.description  = 'Rickety and crudely-fashioned, this ladder descends down into the dropoff, hopefully heading towards something...anything.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end

    def use(player = nil)
      puts 'You grab onto the shaky, rough-hewn, wooden ladder with all your might and start to descend, being extra careful not to loose your grip, which with every moment becomes shakier and shakier.'
      puts

      Animation::run({ :phrase => '*** THUMP ***' })

      puts 'The last couple of steps are more slippery than you anticipated, so you end up fumbling them, falling a few feet onto the hard ground below. When you regain your composure, you notice your conveyance for descending is now far above you and it is, unfortunately, your closest known exit.'
      puts

      {:type => 'move_dangerous', :data => 'Metal Tunnel (South Entrance)'}
    end
  end
end
