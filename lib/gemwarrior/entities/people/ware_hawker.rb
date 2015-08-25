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
    PLAYER_ROX_INSUFFICIENT = 'You have insufficient rox to purchase that. Quit testing me, human.'
    PLAYER_ITEMS_ADDITIONAL = 'Will there be something else?'
    PLAYER_COMMAND_INVALID  = 'That means nothing to me.'

    def initialize
      super

      self.name         = 'ware_hawker'
      self.name_display = 'Ware Hawker'
      self.description  = 'A literal anthropomorphic hawk has set up shop behind a crudely-made table. Some wares are scattered atop its surface, seemingly within anyone\'s grasp, but the hawk\'s piercing eyes seem to belie this observation.'
    end

    def use(world)
      if !self.used
        puts 'You greet the hawk, mentioning that you are interested in the objects presented.'
        STDIN.getc
        puts 'The hawk speaks in a beautiful, yet commanding, tone:'
      end

      hawk_shop(world)
    end

    private

    def hawk_shop(world)
      player_rox_remaining = world.player.rox
      amount_spent = 0
      items_purchased = []

      iron_helmet = IronHelmet.new
      mace = Mace.new
      spear = Spear.new

      speak('I hope you have rox, human. My time affords business transactions, not idle chit chat. What do you want?')
      STDIN.getc

      puts 'A feathered arm quickly moves across the table in an arc suggesting to you that a choice is to be made. Each object has a price tag underneath it, painstakingly written in ink.'
      puts

      puts 'Hawk Shop'.colorize(:cyan)
      puts '---------'
      puts "(1) #{'Iron Helmet'.colorize(:yellow)} - #{PRICE_IRON_HELMET} rox"
      puts "    #{iron_helmet.description}"
      puts "    Defense: +#{iron_helmet.defense} (current: #{world.player.defense})"
      puts "(2) #{'Mace'.colorize(:yellow)}        - #{PRICE_MACE} rox"
      puts "    #{mace.description}"
      puts "    Attack: +#{mace.atk_lo}-#{mace.atk_hi} (current: #{world.player.atk_lo}-#{world.player.atk_hi})"
      puts "(3) #{'Spear'.colorize(:yellow)}       - #{PRICE_SPEAR} rox"
      puts "    #{spear.description}"
      puts "    Attack: +#{spear.atk_lo}-#{spear.atk_hi} (current: #{world.player.atk_lo}-#{world.player.atk_hi})"
      puts
      speak('Choose. Now.')

      loop do
        puts  " 1 - Iron Helmet (#{PRICE_IRON_HELMET})"
        puts  " 2 - Mace        (#{PRICE_MACE})"
        puts  " 3 - Spear       (#{PRICE_SPEAR})"
        print ' x - leave'
        if items_purchased.length > 0
          print ", and buy items\n"
        else
          print "\n"
        end
        puts
        print 'REMAINING GOLD: '
        Animation::run(phrase: player_rox_remaining.to_s, oneline: true)
        print "\n"
        display_shopping_cart(items_purchased)
        print '[HAWK]> '

        choice = gets.chomp.downcase

        case choice
        when '1'
          if player_rox_remaining >= PRICE_IRON_HELMET
            player_rox_remaining -= PRICE_IRON_HELMET
            items_purchased.push(IronHelmet.new)
            amount_spent += PRICE_IRON_HELMET

            speak('The iron helmet? I see.')
            speak(PLAYER_ITEMS_ADDITIONAL)
            next
          else
            speak(PLAYER_ROX_INSUFFICIENT)
            next
          end
        when '2'
          if player_rox_remaining >= PRICE_MACE
            player_rox_remaining -= PRICE_MACE
            items_purchased.push(Mace.new)
            amount_spent += PRICE_MACE

            speak('Yes, fine. Buy a mace.')
            speak(PLAYER_ITEMS_ADDITIONAL)
            next
          else
            speak(PLAYER_ROX_INSUFFICIENT)
            next
          end
        when '3'
          if player_rox_remaining >= PRICE_SPEAR
            player_rox_remaining -= PRICE_SPEAR
            items_purchased.push(Spear.new)
            amount_spent += PRICE_SPEAR

            speak('Hmm. Very well, then. If the spear is what you wish.')
            speak(PLAYER_ITEMS_ADDITIONAL)
            next
          else
            speak(PLAYER_ROX_INSUFFICIENT)
            next
          end
        when 'x'
          if items_purchased.length > 0
            display_shopping_cart(items_purchased)
            speak('Are you certain you wish to buy these things? (y/n)')
            print '[HAWK]> '
            answer = gets.chomp.downcase

            return_type = nil
            case answer
            when 'y', 'yes'
              world.player.rox -= amount_spent
              speak('Take them.')
              return_type = { type: 'purchase', data: items_purchased }
            else
              return_type = { type: nil, data: nil }
            end
          end
          speak('Our business is complete then.')
          return return_type
        else
          speak(PLAYER_COMMAND_INVALID)
          next
        end
      end
    end
  end
end
