# lib/gemwarrior/entities/monster.rb
# Monster creature

require_relative 'creature'

module Gemwarrior
  class Monster < Creature
    attr_accessor :battlecry

    def describe
      status_text =  name.upcase.ljust(20)
      status_text << "LEVEL: #{level.to_s.rjust(2)}, "
      status_text << "HP: #{hp_cur.to_s.rjust(3)}/#{hp_max.to_s.rjust(3)} "
      status_text << "ATK: #{atk_lo.to_s.rjust(2)}-#{atk_hi.to_s.rjust(2)} "
      status_text << "DEF: #{defense.to_s.rjust(2)} "
      status_text << "DEX: #{dexterity.to_s.rjust(2)} "
      status_text << "INV: #{inventory.list_contents} "
      status_text << "ROX: #{rox.to_s.rjust(3)} "
      status_text << "XP: #{xp.to_s.rjust(3)} "
      status_text << "FACE: #{face.ljust(10)} "
      status_text << "HANDS: #{hands.ljust(11)} "
      status_text << "MOOD: #{mood.ljust(10)}\n"
    end
  end
end
