# lib/gemwarrior/entities/monster.rb
# Entity::Creature::Monster

require_relative 'creature'
require_relative 'items/herb'
require_relative 'items/bullet'

module Gemwarrior
  class Monster < Creature
    ITEM_POOL = [Herb.new, Bullet.new]

    attr_accessor :battlecry,
                  :is_boss,
                  :is_dead

    def initialize
      super

      self.inventory  = Inventory.new
      self.useable    = true
      self.talkable   = true
      self.is_dead    = false
      3.times do
        if [true, false].sample
          self.inventory.add_item(ITEM_POOL[rand(0..ITEM_POOL.length-1)])
        end
      end  
    end

    def describe_detailed
      desc_text =  "\"#{name_display}\"".colorize(:yellow)
      desc_text << '(BOSS)'.ljust(13).colorize(:yellow) if is_boss
      desc_text << "\n"
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}\n".colorize(:white)
      desc_text << "FACE : #{face}\n".colorize(:white)
      desc_text << "HANDS: #{hands}\n".colorize(:white)
      desc_text << "MOOD : #{mood}\n".colorize(:white)
      desc_text << "LVL  : #{level}\n".colorize(:white)
      desc_text << "HP   : #{hp_cur}/#{hp_max}\n".colorize(:white)
      desc_text << "ATK  : #{atk_lo}-#{atk_hi}\n".colorize(:white)
      desc_text << "DEF  : #{defense}\n".colorize(:white)
      desc_text << "DEX  : #{dexterity}\n".colorize(:white)
      desc_text << "ROX  : #{rox}\n".colorize(:white)
      desc_text << "XP   : #{xp}\n".colorize(:white)
      desc_text << "INV  : #{inventory.list_contents}\n".colorize(:white)
      desc_text << "DEAD?  #{is_dead}\n".colorize(:white)
      desc_text << "TALK?  #{talkable}\n".colorize(:white)
      desc_text << "USE?   #{useable}\n".colorize(:white)
      desc_text
    end
  end
end
