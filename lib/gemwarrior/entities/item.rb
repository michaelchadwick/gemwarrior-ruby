# lib/gemwarrior/entities/item.rb
# Entity::Item base class

require_relative 'entity'

module Gemwarrior
  class Item < Entity
    attr_accessor :is_armor,
                  :is_weapon

    attr_reader   :use

    def initialize
      super

      self.is_armor   = false
      self.is_weapon  = false
    end

    def use(world)
      'That item does not do anything...yet.'
    end

    def describe_detailed(world)
      desc_text =  "\"#{name_display}\"\n".colorize(:yellow)
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}\n".colorize(:white)
      desc_text << "ARMOR?      #{is_armor}\n".colorize(:white)
      desc_text << "WEAPON?     #{is_weapon}\n".colorize(:white)
      desc_text << "TAKEABLE?   #{takeable}\n".colorize(:white)
      desc_text << "USEABLE?    #{useable}\n".colorize(:white)
      desc_text << "TALKABLE?   #{talkable}\n".colorize(:white)
      desc_text << "CONSUMABLE? #{consumable}\n".colorize(:white)
      desc_text << "EQUIPPABLE? #{equippable}\n".colorize(:white)
      desc_text << "EQUIPPED?   #{equipped}\n".colorize(:white)
      desc_text << "USED?       #{used}\n".colorize(:white)
      desc_text << "USED AGAIN? #{used_again}\n".colorize(:white)
      desc_text << "USES LEFT?  #{number_of_uses}\n".colorize(:white) unless number_of_uses.nil?
      desc_text
    end
  end
end
