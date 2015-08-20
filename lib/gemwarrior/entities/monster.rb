# lib/gemwarrior/entities/monster.rb
# Monster creature

require_relative 'creature'
require_relative 'items/herb'

module Gemwarrior
  class Monster < Creature
    INVENTORY_ITEMS_DEFAULT = [Herb.new]

    attr_accessor :inventory, :battlecry, :is_boss, :is_dead

    def initialize
      if [true, false].sample
        self.inventory = Inventory.new([INVENTORY_ITEMS_DEFAULT[rand(0..INVENTORY_ITEMS_DEFAULT.length-1)]])
      else
        self.inventory = Inventory.new
      end
    end

    def describe
      status_text =  name.upcase.colorize(:green)
      status_text << '(BOSS)'.ljust(13).colorize(:yellow) if is_boss
      status_text << "\n"
      status_text << "#{description}".colorize(:white)
      status_text << "\n"

      status_text << "DEAD? #{is_dead}\n" unless is_dead.nil?
      status_text << "LVL  : #{level}\n".colorize(:white)
      status_text << "HP   : #{hp_cur}/#{hp_max}\n".colorize(:white)
      status_text << "ATK  : #{atk_lo}-#{atk_hi}\n".colorize(:white)
      status_text << "DEF  : #{defense}\n".colorize(:white)
      status_text << "DEX  : #{dexterity}\n".colorize(:white)
      status_text << "ROX  : #{rox}\n".colorize(:white)
      status_text << "XP   : #{xp}\n".colorize(:white)
      status_text << "FACE : #{face}\n".colorize(:white)
      status_text << "HANDS: #{hands}\n".colorize(:white)
      status_text << "MOOD : #{mood}\n".colorize(:white)
      status_text << "INV  : #{inventory.list_contents}".colorize(:white)
      status_text << "\n"
    end
  end
end
