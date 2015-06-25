# lib/gemwarrior/entities/items/arena_master.rb
# Item::ArenaMaster

require_relative '../item'

module Gemwarrior
  class ArenaMaster < Item
    # CONSTANTS
    ARENA_FEE = 50
  
    def initialize
      self.name         = 'arena_master'
      self.description  = 'She wears simple clothing, but carries herself with an air of authority. You think she may be the person to talk with if you want to engage in battle.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end
    
    def use(player = nil)
      puts 'You approach the Arena Master and ask to fight. She snickers to herself, but sees you have a good spirit about you.'
      puts
      
      if player.rox >= 50
        puts "She asks for the requisite payment: #{ARENA_FEE} rox. Do you pay up? (Y/N)"
        answer = gets.chomp.downcase
        case answer
        when 'y', 'yes'
          puts 'She pockets the money and motions toward the center of the arena. She reminds you that you will be facing an ever-worsening onslaught of monsters. Each one you dispatch nets you a bonus cache of rox in addition to whatever the monster gives you. You will also become more experienced the longer you last. Finally, you can give up at any time between battles.'
          puts
          puts 'She finishes by wishing you good luck!'
          
          return {:type => 'arena', :data => nil}
        else
          puts 'She gives you a dirty look, as you have obviously wasted her time. You are told not to mess around with her anymore, and she turns away from you.'
          return {:type => nil, :data => nil}
        end
      else
        puts 'She can tell you seem particularly poor today and says to come back when that has changed.'
        puts
        return {:type => nil, :data => nil}
      end
    end
  end
end
