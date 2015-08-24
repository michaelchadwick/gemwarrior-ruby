# lib/gemwarrior/entities/people/ware_hawker.rb
# Entity::Creature::Person::WareHawker

require_relative '../person'
require_relative '../weapons/mace'
require_relative '../weapons/spear'
require_relative '../armor/iron_helmet'

module Gemwarrior
  class WareHawker < Person
    # CONSTANTS
    PRICE_IRON_HELMET       = 100
    PRICE_MACE              = 200
    PRICE_SPEAR             = 250
    PLAYER_ROX_INSUFFICIENT = '>> "Are you seriously wasting my time? Quit testing me, human."'
    PLAYER_ITEMS_ADDITIONAL = '>> "Will there be something else?"'
    PLAYER_COMMAND_INVALID  = '>> "That means nothing to me."'

    def initialize
      super

      self.name         = 'ware_hawker'
      self.name_display = 'Ware Hawker'
      self.description  = 'A literal anthropomorphic hawk has set up shop behind a crudely-made table. Some wares are scattered atop its surface, seemingly within anyone\'s grasp, but the hawk\'s piercing eyes seem to belie this observation.'
      self.talkable     = true
    end

    def use(player = nil)
      if !self.used
        puts 'You greet the hawk, mentioning that you are interested in the objects presented. The hawk speaks in a beautiful, yet commanding, tone:'
        puts
      end
      
      hawk_shop(player)
    end

    private

    def hawk_shop(player)
      items_purchased = []

      iron_helmet = IronHelmet.new
      mace = Mace.new
      spear = Spear.new

      puts '>> "I hope you have rox, human. My time is amenable to business transactions, not idle chit chat. What do you want?"'
      puts
      puts 'A feathered arm quickly moves across the table in an arc suggesting to you that a choice is to be made. Each object has a price tag underneath it, painstakingly written in ink.'
      puts
      puts "(1) Iron Helmet - #{PRICE_IRON_HELMET} rox"
      puts "    Defense: +#{iron_helmet.defense} (current: #{player.defense})"
      puts "(2) Mace        - #{PRICE_MACE} rox"
      puts "    Attack: +#{mace.atk_lo}-#{mace.atk_hi} (current: #{player.atk_lo}-#{player.atk_hi})"
      puts "(3) Spear       - #{PRICE_SPEAR} rox"
      puts "    Attack: +#{spear.atk_lo}-#{spear.atk_hi} (current: #{player.atk_lo}-#{player.atk_hi})"
      puts
      puts '>> "Choose. Now.'

      loop do
        puts ' 1 - Iron Helmet'
        puts ' 2 - Mace'
        puts ' 3 - Spear'
        puts ' x - leave'
        print '[HAWK]> '
        choice = gets.chomp.downcase

        case choice
        when '1'
          if player.rox >= PRICE_IRON_HELMET
            player.rox -= PRICE_IRON_HELMET
            items_purchased.push(IronHelmet.new)
            puts '>> "Yes, fine."'
            puts PLAYER_ITEMS_ADDITIONAL
            next
          else
            puts PLAYER_ROX_INSUFFICIENT
            next
          end
        when '2'
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
        when '3'
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
