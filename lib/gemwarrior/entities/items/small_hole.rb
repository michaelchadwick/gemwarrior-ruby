# lib/gemwarrior/entities/items/small_hole.rb
# Item::SmallHole

require_relative '../item'
require_relative 'herb'
require_relative 'dagger'

module Gemwarrior
  PLAYER_ROX_INSUFFICIENT = 'You do not have enough rox to purchase that item.'

  class SmallHole < Item
    def initialize
      self.name         = 'small_hole'
      self.description  = 'Amongst the rubble of the alcove, a small hole, barely big enough for a rodent, exists in an absently-minded way near the bottom of the wall.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end
    
    def use(player = nil)
      puts 'You lower yourself to the ground and attempt to peer in the hole in the wall. Just as you begin to think this is a fruitless endeavor, a pair of bright, beady eyes manifest, and an unexpectedly low voice begins speaking to you:'
      
      rat_shop(player)
    end
    
    def reuse(player = nil)
      rat_shop(player)
    end
      
    def rat_shop(player)
      items_purchased = []
    
      puts '>>"Hello, wanderer. Welcome to my establishment, as it were. Are you in need of anything?"'
      puts
      puts 'The creature gently shoves a small slip of paper out of his hole and towards you. You take a peek and notice it has a list of things with prices on it.'
      puts
      puts 'Rockney\'s Hole in the Wall'
      puts '--------------------------'
      puts '(1) Herb     - 10  rox'
      puts '(2) Dagger   - 150 rox'
      puts
      puts '>>"What are you in need of?"'

      loop do
        puts " 1 - Herb"
        puts " 2 - Dagger"
        puts " x - leave"
      
        choice = gets.chomp!
      
        case choice
        when '1'
          if player.rox >= 10
            player.rox -= 10
            items_purchased.push(Herb.new)
            puts '>>"Excellent choice."'
            puts '>>"Anything else?"'
            next
          else
            puts PLAYER_ROX_INSUFFICIENT
            next
          end
        when '2'
          if player.rox >= 150
            player.rox -= 150
            items_purchased.push(Dagger.new)
            puts '>>"A fine blade, indeed."'
            puts '>>"Anything else?"'
            next
          else
            puts PLAYER_ROX_INSUFFICIENT
            next
          end
        when 'x'
          puts '>>"If you need anything further, I\'m always in this hole..."'
          return {:type => 'purchase', :data => items_purchased}
        else
          puts '>>"Huh?"'
          next
        end
      end
    end
  end
end
