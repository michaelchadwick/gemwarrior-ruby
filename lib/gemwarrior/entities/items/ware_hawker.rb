# lib/gemwarrior/entities/items/ware_hawker.rb
# Item::WareHawker

require_relative '../item'
require_relative 'herb'
require_relative 'dagger'

module Gemwarrior
  class WareHawker < Item
    # CONSTANTS
    PRICE_MACE              = 200
    PRICE_SPEAR             = 250
    PLAYER_ROX_INSUFFICIENT = '>> "Are you seriously wasting my time? You are testing me, human."'
    PLAYER_ITEMS_ADDITIONAL = '>> "Will there be something else?"'
    PLAYER_COMMAND_INVALID  = '>> "That means nothing to me."'

    def initialize
      super

      self.name         = 'ware_hawker'
      self.description  = 'A literal anthropomorphic hawk has set up shop behind a crudely-made table. Some wares are scattered atop its surface, seemingly within anyone\'s grasp, but the hawk\'s piercing eyes seem to belie this observation.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.talkable     = true
    end

    def use(player = nil)
      puts 'You greet the hawk, mentioning that you are interested in the objects presented. The hawk speaks in a beautiful, yet commanding, tone:'
      puts

      hawk_shop(player)
    end

    def reuse(player = nil)
      hawk_shop(player)
    end

    def hawk_shop(player)
      items_purchased = []
    
      puts '>> "I hope you have rox, human. My time is amenable to business transactions, not idle chit chat. What do you want?"'
      puts
      puts 'A feathered arm quickly moves across the table in an arc suggesting to you that a choice is to be made. Each object has a price tag underneath it, painstakingly written in ink.'
      puts
      puts "(1) Mace     - #{PRICE_MACE} rox"
      puts "(2) Spear    - #{PRICE_SPEAR} rox"
      puts
      puts '>> "Choose. Now.'

      loop do
        puts ' 1 - Mace'
        puts ' 2 - Spear'
        puts ' x - leave'
        print '[HAWK]> '
        choice = gets.chomp.downcase

        case choice
        when '1'
          if player.rox >= PRICE_MACE
            player.rox -= PRICE_MACE
            items_purchased.push(Mace.new)
            puts '>> "Yes, fine."'
            puts PLAYER_ITEMS_ADDITIONAL
            next
          else
            puts PLAYER_ROX_INSUFFICIENT
            next
          end
        when '2'
          if player.rox >= PRICE_SPEAR
            player.rox -= PRICE_SPEAR
            items_purchased.push(Spear.new)
            puts '>> "Hmph. Very well, then."'
            puts PLAYER_ITEMS_ADDITIONAL
            next
          else
            puts PLAYER_ROX_INSUFFICIENT
            next
          end
        when 'x'
          puts '>> "Our business is complete then."'
          return { type: 'purchase', data: items_purchased }
        else
          puts PLAYER_COMMAND_INVALID
          next
        end
      end
    end
  end
end
