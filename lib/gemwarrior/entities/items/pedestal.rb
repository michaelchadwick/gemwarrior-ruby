# lib/gemwarrior/entities/items/pedestal.rb
# Entity::Item::Pedestal

require_relative '../item'

module Gemwarrior
  class Pedestal < Item
    # CONSTANTS
    USE_TEXT = '** WHOOOOOSH **'

    attr_accessor :switches

    def initialize
      super

      self.name         = 'pedestal'
      self.name_display = 'Pedestal'
      self.description  = 'A pedestal about 4 feet in height rises up from the ground, with six switches arranged vertically above a large gem affixed to the top. The switches each have a word next to them in some language that looks familiar yet strange. Each letter is made of some kind of ink crudely splashed on stone, and each can be moved to arrange them in a different fashion than they are now. The large gem glitters with utter brilliance.'
      self.switches     = init_switches
    end

    def init_switches
      self.switches = [
        ['iolita',      jumble('iolita'),     nil],
        ['rockney',     jumble('rockney'),    nil],
        ['emerald',     jumble('emerald'),    nil],
        ['ruby',        jumble('ruby'),       nil],
        ['amberoo',     jumble('amberoo'),    nil],
        ['alexandrat',  jumble('alexandrat'), nil]
      ]

      self.switches = self.switches.sort_by { rand }
    end

    def use(world)
      puts 'You look at the pedestal and its switches. The raised gem beckons you to push it and, deductively, you believe that pressing it will do something. However, those switches probably have something to do with the result.'

      loop do
        print_switches(self.switches)

        puts
        puts 'You can rearrange the letters in the words themselves, and you can push the large gem. What do you do?'
        puts
        puts '>> 1 Rearrange the letters in switch 1\'s word'
        puts '>> 2 Rearrange the letters in switch 2\'s word'
        puts '>> 3 Rearrange the letters in switch 3\'s word'
        puts '>> 4 Rearrange the letters in switch 4\'s word'
        puts '>> 5 Rearrange the letters in switch 5\'s word'
        puts '>> 6 Rearrange the letters in switch 6\'s word'
        puts '>> 7 Push the large gem into the pedestal'
        puts '>> 8 Stop this nonsense'
        puts

        print '> '
        choice = gets.chomp!

        case choice
        when '1'
          switch1 = switches[0][2].nil? ? switches[0][1] : switches[0][2]
          puts "Switch 1: #{switch1}"
          puts 'What should the switch\'s word be set to?'
          switches[0][2] = get_new_word(switch1)
        when '2'
          switch2 = switches[1][2].nil? ? switches[1][1] : switches[1][2]
          puts "Switch 2: #{switch2}"
          puts 'What should the switch\'s word be set to?'
          switches[1][2] = get_new_word(switch2)
        when '3'
          switch3 = switches[2][2].nil? ? switches[2][1] : switches[2][2]
          puts "Switch 3: #{switch3}"
          puts 'What should the switch\'s word be set to?'
          switches[2][2] = get_new_word(switch3)
        when '4'
          switch4 = switches[3][2].nil? ? switches[3][1] : switches[3][2]
          puts "Switch 4: #{switch4}"
          puts 'What should the switch\'s word be set to?'
          switches[3][2] = get_new_word(switch4)
        when '5'
          switch5 = switches[4][2].nil? ? switches[4][1] : switches[4][2]
          puts "Switch 5: #{switch5}"
          puts 'What should the switch\'s word be set to?'
          switches[4][2] = get_new_word(switch5)
        when '6'
          switch6 = switches[5][2].nil? ? switches[5][1] : switches[5][2]
          puts "Switch 6: #{switch6}"
          puts 'What should the switch\'s word be set to?'
          switches[5][2] = get_new_word(switch6)
        when '7'
          pedestal_configured = true

          for i in 0..switches.length-1 do
            pedestal_configured = false unless switches[i][0].downcase.eql? switches[i][2].downcase
          end

          if pedestal_configured
            Audio.play_synth(:uncover_secret)
            puts 'You push the large gem into the pedestal and it descends without a hitch, almost as if it were meant to be. The pedestal begins to violently shake and a strong gust of wind picks you up off the ground. You feel completely taken aback and unsettled, but you have no choice: you are being whisked away somewhere into the sky, destination unknown.'.colorize(:yellow)

            # stats
            world.player.movements_made += 1

            Animation.run(phrase: USE_TEXT)
            return { type: 'move', data: 'Sky Tower (Entryway)' }
          else
            puts 'You attempt to push the large gem, but it puts up quite the resistance, and nothing much else happens. Your attention once again returns to the pedestal and its switches.'.colorize(:red)
          end
        when '8'
          puts 'You step away from the mysterious pedestal.'
          return { type: nil, data: nil }
        else
          next
        end
      end
    end

    private

    def print_switches(switches)
      puts

      switch1 = switches[0][2].nil? ? switches[0][1] : switches[0][2]
      puts "Switch 1: #{switch1}"

      switch2 = switches[1][2].nil? ? switches[1][1] : switches[1][2]
      puts "Switch 2: #{switch2}"

      switch3 = switches[2][2].nil? ? switches[2][1] : switches[2][2]
      puts "Switch 3: #{switch3}"

      switch4 = switches[3][2].nil? ? switches[3][1] : switches[3][2]
      puts "Switch 4: #{switch4}"

      switch5 = switches[4][2].nil? ? switches[4][1] : switches[4][2]
      puts "Switch 5: #{switch5}"

      switch6 = switches[5][2].nil? ? switches[5][1] : switches[5][2]
      puts "Switch 6: #{switch6}"
    end

    def jumble(word)
      word.split(//).sort_by { rand }.join('')
    end

    def get_new_word(switch)
      new_word = gets.chomp!
      if switch.downcase.split(//).sort == new_word.downcase.split(//).sort
        return new_word
      else
        puts 'Those letters are not in the original word, sorry.'.colorize(:red)
        return nil
      end
    end
  end
end
