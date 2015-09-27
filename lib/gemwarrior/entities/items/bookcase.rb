# lib/gemwarrior/entities/items/bookcase.rb
# Entity::Item::Bookcase

require_relative '../item'

module Gemwarrior
  class Bookcase < Item
    # CONSTANTS
    OPEN_TEXT = '** BRRRRRNNNGG **'

    def initialize
      super

      self.name         = 'bookcase'
      self.name_display = 'Bookcase'
      self.description  = 'This oaken monstrosity has six shelves, each about 3 feet high. Mathing, you determine it to be "huge", featuring many books within it.'
    end

    def use(world)
      forest_southwest = world.location_by_name('forest-southwest')

      if forest_southwest.paths[:west].eql? false
        if !self.used
          puts 'Many books look interesting, including one specific volume entitled "Use Me Again to Attempt Unlocking the Way", by Not Very Subtle.'
          puts
          self.used = true
        else
          puts 'You pull out the tome entitled "Use Me Again to Attempt Unlocking the Way".'
          STDIN.getc
          puts 'Opening the book, you see a question on the inside cover:'
          puts '>> "What do you get when an underground excavator is named after a famous "weird" guy?"'
          answer = gets.chomp.downcase

          case answer
          when 'mineral'
            Audio.play_synth(:uncover_secret)
            forest_southwest.paths[:west] = true
            puts
            Animation.run(phrase: OPEN_TEXT)
            puts
            puts 'After you shout out your answer to the book\'s question to no one in particular, you manage to see a clearing in the forest to the west that was presumably not there before. Huh.'
            STDIN.getc

            puts 'Before getting back to your travels, however, you notice the book\'s back cover warns: "The path westward is a difficult one and has fallen many an adventurer. Take care before venturing thataway."'
          else
            puts 'For some reason, you blurt out an answer to the unhearing trees, feel embarrassed, and put the book back in the bookcase.'
          end
        end

        { type: nil, data: nil }
      else
        puts 'You pull out a book here and there, glancing at their weathered pages and scuffed bindings. Nothing really interests you and it is back to staring at the forest.'
      end

      { type: nil, data: nil }
    end
  end
end
