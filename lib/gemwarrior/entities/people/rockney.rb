# lib/gemwarrior/entities/people/rockney.rb
# Entity::Creature::Person::Rockney

require_relative '../item'
require_relative '../items/herb'
require_relative '../weapons/dagger'

module Gemwarrior
  class Rockney < Item
    # CONSTANTS
    PRICE_HERB              = 10
    PRICE_DAGGER            = 150
    PLAYER_ROX_INSUFFICIENT = 'Pity. You are a bit short on funds to purchase that item.'
    PLAYER_ITEMS_ADDITIONAL = 'Anything else?'
    PLAYER_COMMAND_INVALID  = 'Huh?'

    def initialize
      super

      self.name         = 'rockney'
      self.name_display = 'Rockney'
      self.description  = 'The rat with a name looks at you, not with malice, but with kindness. Odd for a rodent hiding in a hole in a dark, metal tunnel.'
      self.talkable     = true
    end

    def use(world)
      if !self.used
        puts 'You\'re not sure what to expect when you confront the small animal living in the crevice, but you figure it\'s this or doing anything else at all, so...'
        puts
      end

      rat_shop(player)
    end

    private

    def rat_shop(player)
      player_rox_remaining = player.rox
      amount_spent = 0
      items_purchased = []

      herb = Herb.new
      dagger = Dagger.new

      speak('Hello, wanderer. Welcome to my establishment, as it were. Are you in need of anything?')
      puts
      puts 'The creature gently shoves a small slip of paper out of his hole and towards you. You take a peek and notice it has a list of things with prices on it.'
      puts
      puts 'Rockney\'s Hole in the Wall'.colorize(:cyan)
      puts '--------------------------'
      puts "(1) #{'Herb'.colorize(:yellow)}     - #{PRICE_HERB} rox"
      puts "    #{herb.description}"
      puts "(2) #{'Dagger'.colorize(:yellow)}   - #{PRICE_DAGGER} rox"
      puts "    #{dagger.description}"
      puts "    Attack: +#{dagger.atk_lo}-#{dagger.atk_hi} (current: #{player.atk_lo}-#{player.atk_hi})"
      puts
      speak('What are you in need of?')

      loop do
        puts  " 1 - Herb   #{PRICE_HERB}"
        puts  " 2 - Dagger #{PRICE_DAGGER}"
        print ' x - leave'
        if items_purchased.length > 0
          print ", and buy items\n"
        else
          print "\n"
        end
        puts
        print 'REMAINING GOLD: '
        Animation.run(phrase: player_rox_remaining.to_s, oneline: true)
        print "\n"
        display_shopping_cart(items_purchased)
        print '[ROCKNEY]>? '

        choice = gets.chomp.downcase

        case choice
        when '1'
          if player_rox_remaining >= PRICE_HERB
            player_rox_remaining -= PRICE_HERB
            items_purchased.push(Herb.new)
            amount_spent += PRICE_HERB

            speak('Excellent choice.')
            speak(PLAYER_ITEMS_ADDITIONAL)
            next
          else
            speak(PLAYER_ROX_INSUFFICIENT)
            next
          end
        when '2'
          if player.rox >= PRICE_DAGGER
            player.rox -= PRICE_DAGGER
            items_purchased.push(Dagger.new)
            amount_spent += PRICE_DAGGER

            display_shopping_cart(items_purchased)
            speak('A fine blade, indeed.')
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
            print '[ROCKNEY]> '

            answer = gets.chomp.downcase

            return_type = nil
            case answer
            when 'y', 'yes'
              player.rox -= amount_spent
              speak('Enjoy!')
              return_type = { type: 'purchase', data: items_purchased }
            else
              return_type = { type: nil, data: nil }
            end
          end
          speak('If you need anything further, I\'m always in this hole...')
          return return_type
        else
          speak(PLAYER_COMMAND_INVALID)
          next
        end
      end
    end
  end
end
