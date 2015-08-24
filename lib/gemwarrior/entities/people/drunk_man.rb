# lib/gemwarrior/entities/people/drunk_man.rb
# Entity::Creature::Person::DrunkMan

require_relative '../person'
require_relative '../../misc/formatting'

module Gemwarrior
  class DrunkMan < Person
    include Formatting

    def initialize
      super

      self.name         = 'drunk_man'
      self.name_display = 'Drunk Man'
      self.description  = 'Some supernatural force is surely keeping this obviously smashed individual from toppling over to the ground. The inebriated fellow somehow continues to stumble about in a small circle near a smattering of shipping crates, looking simultaneously dazed and cheerful.'
    end

    def use(player = nil)
      choose_blurting

      self.used = [true, false].sample

      { type: nil, data: nil }
    end

    private

    def choose_blurting
      choice = [1, 2, 3, 4].sample

      case choice
      when 1
        print '>> "'
        print to_hooch('I still can\'t believe I lost at the Arena! I was doing so well, and then a slippery citrinaga got a cheap shot on me.')
        print '"'
        print "\n"
        print '>> "'
        print to_hooch('Ehhh. Someday I\'ll be back and I\'ll be victorious. That smarmy Arena Master ain\'t gettin\' the last word!')
        print '"'
        print "\n"
      when 2
        print '>> "'
        print to_hooch('Maybe I just needed a better weapon that last fight in the arena. Yeah! That must be it.')
        print '"'
        print "\n"
      when 3
        print '>> "'
        print to_hooch('Man, my head really hurts. I\'m not sure if it\'s because of the fighting or the booze.')
        print '"'
        print "\n"
        print '>> "'
        print to_hooch('I should probably get something else to drink.')
        print '"'
        print "\n\n"
        puts 'The man looks like he has thought of something genius for a moment, but then scratches his head while stumbling around in his well-worn circle again.'
      when 4
        print '>> "'
        print to_hooch('Ahhhhhhhhhhhhhhhhhhhh!')
        print '"'
        print "\n\n"
        puts  'He begins to quickly become frantic as he notices you approaching, and then falls over, crumpled to the floor.'
        puts
        puts  'You approach to check if he\'s still breathing. As you get closer, he gets back up, hardly noticing you, and begins his spiral once again.'
      end
    end
  end
end
