# lib/gemwarrior/entities/monster.rb
# Monster creature

require_relative 'creature'

module Gemwarrior
  class Monster < Creature
    attr_accessor :battlecry, :is_boss

    def describe
      status_text =  name.upcase.ljust(26).colorize(:green)
      status_text << "LEVEL: #{level.to_s.rjust(2)}, ".colorize(:white)
      status_text << "HP: #{hp_cur.to_s.rjust(3)}/#{hp_max.to_s.rjust(3)} ".colorize(:white)
      status_text << "ATK: #{atk_lo.to_s.rjust(2)}-#{atk_hi.to_s.rjust(2)} ".colorize(:white)
      status_text << "DEF: #{defense.to_s.rjust(2)} ".colorize(:white)
      status_text << "DEX: #{dexterity.to_s.rjust(2)} ".colorize(:white)
      status_text << "ROX: #{rox.to_s.rjust(3)} ".colorize(:white)
      status_text << "XP: #{xp.to_s.rjust(3)} ".colorize(:white)
      status_text << "FACE: #{face.ljust(12)} ".colorize(:white)
      status_text << "HANDS: #{hands.ljust(12)} ".colorize(:white)
      status_text << "MOOD: #{mood.ljust(12)}".colorize(:white)
      status_text << "INV: #{inventory.list_contents}\n".colorize(:white)
    end
  end
end
