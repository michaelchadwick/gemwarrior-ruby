# lib/gemwarrior/entities/items/snowman.rb
# Entity::Item::Snowman

require_relative '../item'

module Gemwarrior
  class Snowman < Item
    # CONSTANTS
    USE_TEXT = '** FOOOOSH **'

    def initialize
      super

      self.name         = 'snowman'
      self.name_display = 'Snowman'
      self.description  = 'Standing solemnly in the snow, a man of snow solemnly stands.'
    end

    def use(player = nil)
      puts 'You go to touch the snowy softness of the snowman when it magically comes to life! The frozen homunculus grabs you by the wrist and tosses you to the ground, only to follow this up by jumping onto you with its full, freezing, force. Your body, and mind, go numb.'
      puts

      Animation::run(phrase: USE_TEXT)

      { type: 'move_dangerous', data: 'Home' }
    end
  end
end
