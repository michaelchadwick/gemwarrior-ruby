# lib/gemwarrior/entities/monster.rb
# Monster creature

require_relative 'creature'

module Gemwarrior
  class Monster < Creature
    attr_accessor :xp, :atk_hi, :atk_lo, :dexterity, 
                  :rox_to_give, :xp_to_give, :battlecry
  
    def initialize(options)
      self.id           = options[:id]
      self.name         = options[:name]
      self.description  = options[:description]
      self.face         = options[:face]
      self.hands        = options[:hands]
      self.mood         = options[:mood]
      
      self.level        = options[:level]
      self.hp_cur       = options[:hp_cur]
      self.hp_max       = options[:hp_max]
      
      self.atk_lo       = options[:atk_lo]
      self.atk_hi       = options[:atk_hi]
      self.dexterity    = options[:dexterity]
      
      self.inventory    = options[:inventory]
      self.rox_to_give  = options[:rox_to_give]
      self.xp_to_give   = options[:xp_to_give]
      
      self.battlecry    = options[:battlecry]
    end
    
    def describe
      status_text =  name.upcase.ljust(13)
      status_text << "LEVEL: #{level.to_s.rjust(2)}, "
      status_text << "HP: #{hp_cur.to_s.rjust(3)}/#{hp_max.to_s.rjust(3)}, "
      status_text << "ATK: #{atk_lo.to_s.rjust(2)}-#{atk_hi.to_s.rjust(2)}, "
      status_text << "DEX: #{dexterity.to_s.rjust(3)}, "
      status_text << "XP: #{xp_to_give.to_s.rjust(3)}, "
      status_text << "ROX: #{rox_to_give.to_s.rjust(3)}, "
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
