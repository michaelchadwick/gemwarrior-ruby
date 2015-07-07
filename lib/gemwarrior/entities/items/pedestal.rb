# lib/gemwarrior/entities/items/pedestal.rb
# Item::Pedestal

require_relative '../item'

module Gemwarrior
  class Pedestal < Item  
    attr_accessor :switches

    def initialize
      self.name         = 'pedestal'
      self.description  = 'A pedestal about 4 feet in height rises up from the ground, with six switches arranged vertically above a large gem affixed to the top. The switches each have a word next to them in some language that looks familiar yet strange. Each letter is made of some kind of ink crudely splashed on stone, and each can be moved to arrange them in a different fashion than they are now. The large gem glitters with utter brilliance.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
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

    def use(player = nil)
      puts 'You look at the pedestal and its switches. The raised gem beckons you to push it and, deductively, you believe that pressing it will do something. However, those switches probably have something to do with the result.'
      
      loop do
        print_switches(self.switches)
        
        puts 
        puts 'You can change the words themselves and you can push the large gem. What do you do?'
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
          new_word = gets.chomp!
          switches[0][2] = new_word
        when '2'
          switch2 = switches[1][2].nil? ? switches[1][1] : switches[1][2]
          puts "Switch 2: #{switch2}"
          puts 'What should the switch\'s word be set to?'
          new_word = gets.chomp!
          switches[1][2] = new_word
        when '3'
          switch3 = switches[2][2].nil? ? switches[2][1] : switches[2][2]
          puts "Switch 3: #{switch3}"
          puts 'What should the switch\'s word be set to?'
          new_word = gets.chomp!
          switches[2][2] = new_word
        when '4'
          switch4 = switches[3][2].nil? ? switches[3][1] : switches[3][2]
          puts "Switch 4: #{switch4}"
          puts 'What should the switch\'s word be set to?'
          new_word = gets.chomp!
          switches[3][2] = new_word
        when '5'
          switch5 = switches[4][2].nil? ? switches[4][1] : switches[4][2]
          puts "Switch 5: #{switch5}"
          puts 'What should the switch\'s word be set to?'
          new_word = gets.chomp!
          switches[4][2] = new_word
        when '6'
          switch6 = switches[5][2].nil? ? switches[5][1] : switches[5][2]
          puts "Switch 6: #{switch6}"
          puts 'What should the switch\'s word be set to?'
          new_word = gets.chomp!
          switches[5][2] = new_word
        when '7'
          pedestal_configured = true
      
          for i in 0..switches.length-1 do
            pedestal_configured = false unless switches[i][0].eql? switches[i][2]
          end   
      
          if pedestal_configured
            puts 'You push the large gem into the pedestal and it descends without a hitch, almost as if it were meant to be. The pedestal begins to violently shake and a strong gust of wind picks you up off the ground. You feel completely taken aback and unsettled, but you have no choice: you are being whisked away somewhere into the sky, destination unknown.'.colorize(:yellow)
            
            # stats
            player.movements_made += 1
            
            Animation::run({ :phrase => '*** WHOOOOOSH ***' })
            return {:type => 'move', :data => 'Sky Tower (Entryway)'}
          else
            puts 'You attempt to push the large gem, but it puts up quite the resistance, and nothing much else happens. Your attention once again returns to the pedestal and its switches.'.colorize(:red)
          end
        when '8'
          puts 'You step away from the mysterious pedestal.'
          return {:type => nil, :data => nil}
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
  end
end
