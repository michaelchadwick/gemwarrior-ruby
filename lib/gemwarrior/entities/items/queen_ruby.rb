# lib/gemwarrior/entities/items/queen_ruby.rb
# Item::QueenRuby

require_relative '../item'
require_relative '../../misc/animation'

module Gemwarrior
  class QueenRuby < Item
    # CONSTANTS
    MOVE_TEXT = '*** WHOOOOOOSH ***'
    
    def initialize
      super

      self.name         = 'queen_ruby'
      self.description  = 'Queen Ruby glimmers like she was made from the substance of her name. She wears a wan smile, and her hands are delicately intertwined as she sits patiently.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.equippable   = false
      self.talkable     = true
    end

    def use(player = nil)
      puts '>> "Thank you for bringing back the ShinyThing(tm)! The land of Jool is saved!"'
      STDIN.getch
      puts ">> \"Please, #{player.name}, hand the ShinyThing(tm) to me, before all is lost!\""
      puts
      print 'Hand over the ShinyThing(tm)? (y/n) '
      answer = gets.chomp.downcase
      
      case answer
      when 'y', 'yes'
        player.inventory.remove_item('sparkly_thing')
        print '>> "Oh, thank you! Now that the evil Emerald is defeated, and I, Queen Ruby, have the ShinyThing(tm) again, peace can come to the land of Jool. Your reward is...'
        STDIN.getch
        Animation::run(phrase: '...', oneline: true)
        STDIN.getch
        Animation::run(phrase: '...', oneline: true)
        STDIN.getch
        Animation::run(phrase: '...my thanks!"', oneline: true)
        STDIN.getch
        puts
        puts '>> "Now, be a dear and run on home."'
        puts
        STDIN.getch
        puts 'And with that, she waves her arm in a tired, yet mystical, manner. Your mind and sight go blank, and you "poof" out of existence.'
        puts
        
        Animation::run(phrase: MOVE_TEXT)
        { type: 'move', data: 'Home' }
      when 'n', 'no'
        puts '>> "No? No??? Well, you are not leaving this room until you do, so think long and hard about that."'
        { type: nil, data: nil }
      else
        puts '>> "Take your time and let me know when you are going to give me the ShinyThing(tm), all right?"'
        { type: nil, data: nil }
      end
    end
  end
end
