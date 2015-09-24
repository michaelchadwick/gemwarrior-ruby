# lib/gemwarrior/entities/armor.rb
# Entity::Item::Armor base class

require_relative 'item'

module Gemwarrior
  class Armor < Item
    attr_accessor :defense

    def initialize
      super

      self.equippable = true
      self.defense    = 0
      self.is_armor   = true
    end

    def use(world)
      'Save the donning of this piece of armor for battle.'
    end

    def describe_detailed
      desc_text =  "\"#{name_display}\"\n".colorize(:yellow)
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}\n".colorize(:white)
      desc_text << "ARMOR?      #{is_armor}\n".colorize(:white)
      desc_text << "DEFENSE:    #{defense}\n".colorize(:white)
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
