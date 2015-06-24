# lib/gemwarrior/entities/items/snowman.rb
# Item::Snowman

require_relative '../item'

module Gemwarrior
  class Snowman < Item
    def initialize
      self.name         = 'snowman'
      self.description  = 'Standing solemnly in the snow, a man of snow solemnly stands.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end
    
    def use(inventory = nil)
      puts 'You go to touch the snowy softness of the snowman when it magically comes to life! The frozen homunculus grabs you by the wrist and tosses you to the ground, only to follow this up by jumping onto you with its full, freezing, force. Your body, and mind, go numb.'
      puts

      Animation::run({ :phrase => '*** FOOOOSH ***' })

      {:type => 'move_dangerous', :data => 'Home'}
    end
  end
end
