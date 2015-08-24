# lib/gemwarrior/entities/item.rb
# Entity::Item base class

require_relative 'entity'

module Gemwarrior
  class Item < Entity
    attr_accessor :takeable,
                  :useable,
                  :equippable,
                  :equipped,
                  :consumable,
                  :used,
                  :number_of_uses
                  
    attr_reader   :use

    def initialize
      super

      self.takeable       = false
      self.useable        = true
      self.equippable     = false
      self.equipped       = false
      self.consumable     = false
      self.used           = false
      self.number_of_uses = nil
    end

    def use(player = nil)
      'That item does not do anything...yet.'
    end

    def describe_detailed
      desc_text =  "\"#{name_display}\"\n".colorize(:yellow)
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}\n".colorize(:white)
      desc_text << "TAKEABLE?   #{takeable}\n".colorize(:white)
      desc_text << "TALKABLE?   #{talkable}\n".colorize(:white)
      desc_text << "USEABLE?    #{useable}\n".colorize(:white)
      desc_text << "EQUIPPABLE? #{equippable}\n".colorize(:white)
      desc_text << "EQUIPPED?   #{equipped}\n".colorize(:white)
      desc_text << "CONSUMABLE? #{consumable}\n".colorize(:white)
      desc_text << "USED?       #{used}\n".colorize(:white)
      desc_text << "USES LEFT?  #{number_of_uses}\n".colorize(:white) unless number_of_uses.nil?
      desc_text
    end
  end
end
