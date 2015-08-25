# lib/gemwarrior/entities/people/queen_ruby.rb
# Entity::Creature::Person::QueenRuby

require_relative '../person'
require_relative '../../misc/animation'

module Gemwarrior
  class QueenRuby < Person
    # CONSTANTS
    MOVE_TEXT = '** WHOOOOOOSH **'

    def initialize
      super

      self.name         = 'queen_ruby'
      self.name_display = 'Queen Ruby'
      self.description  = 'Queen Ruby glimmers like she was made from the substance of her name. She wears a wan smile, and her hands are delicately intertwined as she sits patiently.'
    end

    def use(world)
      speak('Thank you for bringing back the ShinyThing(tm)! The land of Jool is saved!')
      STDIN.getc
      speak("Please, #{world.player.name}, hand the ShinyThing(tm) to me, before all is lost!")

      print 'Hand over the ShinyThing(tm)? (y/n) '
      answer = gets.chomp.downcase

      case answer
      when 'y', 'yes'
        if world.player.inventory.contains_item?('sparkly_thing')
          world.player.inventory.remove_item('sparkly_thing')
          speak('Oh, thank you! Now that the evil Emerald is defeated, and I, Queen Ruby, have the ShinyThing(tm) again, peace can come to the land of Jool.')
          speak('Your reward is', no_end_quote = true, no_line_feed = true)
          Animation.run(phrase: '......', oneline: true, speed: :slow, color: :yellow, numeric: false, alpha: false)
          Animation.run(phrase: 'my thanks!', oneline: true, speed: :insane, color: :yellow)
          print '"'.colorize(:yellow)
          print "\n"
          STDIN.getc
          puts 'You feel an audible groan spill out of your mouth, but Queen Ruby doesn\'t seem to notice.'
          STDIN.getc
          speak('Now, be a dear and run on home.')
          STDIN.getc
          puts 'And with that, she waves her arm in a tired, yet mystical, manner. Your mind and sight go blank, and you "poof" out of existence.'
          puts

          Animation.run(phrase: MOVE_TEXT)
          puts
          return { type: 'move', data: 'home' }
        else
          speak('Hold on a minute!', no_end_quote = false, no_line_feed = true)
          STDIN.getc
          speak('You don\'t even have the SparklyThing(tm)!', no_end_quote = false, no_line_feed = true)
          STDIN.getc
          speak('How on earth did you even get here without unknowningly being transported after acquiring it?', no_end_quote = false, no_line_feed = true)
          STDIN.getc
          speak('...', no_end_quote = false, no_line_feed = true)
          STDIN.getc
          speak('...are you a wizard?!')

          return { type: nil, data: nil }
        end
      when 'n', 'no'
        speak('No? No??? Well, you are not leaving this room until you do, so think long and hard about that.')
        return { type: nil, data: nil }
      else
        speak('Hmm. I see. Take your time and let me know when you are going to give me the ShinyThing(tm), all right?')
        return { type: nil, data: nil }
      end
    end
  end
end
