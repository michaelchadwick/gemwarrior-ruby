# lib/gemwarrior/entities/monster.rb
# Monster creature

require_relative 'creature'
require_relative 'items/herb'

module Gemwarrior
  class Monster < Creature
    INVENTORY_ITEMS_DEFAULT = [Herb.new]

    attr_accessor :inventory, :battlecry, :is_boss

    def initialize
      if [true, false].sample
        self.inventory = Inventory.new([INVENTORY_ITEMS_DEFAULT[rand(0..INVENTORY_ITEMS_DEFAULT.length-1)]])
      else
        self.inventory = Inventory.new
      end
    end

    def describe
      status_text =  name.upcase.ljust(13).colorize(:green)
      status_text << "#{description}\n".colorize(:white)
      if is_boss
        status_text << '(BOSS)'.ljust(13).colorize(:yellow)
      else
        status_text << ''.ljust(13)
      end
      status_text << "LEVEL: #{level.to_s.rjust(2)}, ".colorize(:white)
      status_text << "HP: #{hp_cur.to_s.rjust(3)}/#{hp_max.to_s.rjust(3)} ".colorize(:white)
      status_text << "ATK: #{atk_lo.to_s.rjust(2)}-#{atk_hi.to_s.rjust(2)} ".colorize(:white)
      status_text << "DEF: #{defense.to_s.rjust(2)} ".colorize(:white)
      status_text << "DEX: #{dexterity.to_s.rjust(2)} ".colorize(:white)
      status_text << "ROX: #{rox.to_s.rjust(3)} ".colorize(:white)
      status_text << "XP: #{xp.to_s.rjust(3)} ".colorize(:white)
      status_text << "\n".ljust(14)
      status_text << "FACE: #{face} ".colorize(:white)
      status_text << "HANDS: #{hands} ".colorize(:white)
      status_text << "MOOD: #{mood} ".colorize(:white)
      status_text << "INV: #{inventory.list_contents}".colorize(:white)
      status_text << "\n"
    end
  end
end
