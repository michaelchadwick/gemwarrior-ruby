# lib/gemwarrior/monster.rb
# Monster creature

require_relative 'creature'

module Gemwarrior
  class Monster < Creature
    attr_accessor :xp, :atk_hi, :atk_lo, :dexterity, :rox, :xp_to_give, :battlecry
  
    def initialize(
      id, 
      name, 
      description, 
      face,
      hands, 
      mood, 
      level, 
      hp_cur, 
      hp_max, 
      atk_lo, 
      atk_hi, 
      dexterity,
      inventory, 
      rox,
      xp_to_give,
      battlecry
    )
      self.id = id
      self.name = name
      self.description = description
      self.face = face
      self.hands = hands
      self.mood = mood
      
      self.level = level
      self.hp_cur = hp_cur
      self.hp_max = hp_max
      
      self.atk_lo = atk_lo
      self.atk_hi = atk_hi
      self.dexterity = dexterity
      
      self.inventory = inventory
      self.rox = rox
      self.xp_to_give = xp_to_give
      
      self.battlecry = battlecry
    end
    
    def status
      status_text =  name.upcase.ljust(14)
      status_text << "LEVEL: #{level.to_s.rjust(2)}, "
      status_text << "HP: #{hp_cur.to_s.rjust(3)}/#{hp_max.to_s.rjust(3)}, "
      status_text << "ATK: #{atk_lo.to_s.rjust(2)}-#{atk_hi.to_s.rjust(2)}, "
      status_text << "DEX: #{dexterity.to_s.rjust(3)}, "
      status_text << "XP: #{xp_to_give.to_s.rjust(3)}, "
      status_text << "FACE: #{face.ljust(10)}, "
      status_text << "HANDS: #{hands.ljust(10)}, "
      status_text << "MOOD: #{mood.ljust(10)}\n"
      status_text.to_s
    end
    
    def take_damage(dmg)
      self.hp_cur = hp_cur.to_i - dmg.to_i
    end

  end
end
