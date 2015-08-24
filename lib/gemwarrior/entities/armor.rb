# lib/gemwarrior/entities/armor.rb
# Entity::Item::Armor base class

require_relative 'item'

module Gemwarrior
  class Armor < Item
    attr_accessor :defense,
                  :is_armor

    def initialize
      super

      self.defense  = 0
      self.is_armor = true
    end

    def use(inventory = nil)
      'Save the donning of this piece of armor for battle.'
    end

    def describe
      desc_text =  "\"#{name_display}\"\n".colorize(:yellow)
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}\n".colorize(:white)
      desc_text << "DEFENSE:    #{defense}\n".colorize(:white)
      desc_text << "TAKEABLE?   #{takeable}\n".colorize(:white)
      desc_text << "USEABLE?    #{useable}\n".colorize(:white)
      desc_text << "EQUIPPABLE? #{equippable}\n".colorize(:white)
      desc_text << "EQUIPPED?   #{equipped}\n".colorize(:white)
      desc_text
    end
  end
end
