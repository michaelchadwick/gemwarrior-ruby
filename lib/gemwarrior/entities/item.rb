# lib/gemwarrior/entities/item.rb
# Item base class

require_relative 'entity'

module Gemwarrior
  class Item < Entity
    attr_accessor :atk_lo, :atk_hi, :takeable, :useable, :equippable, :equipped,
                  :consumable, :use, :used, :number_of_uses, :talkable

    def initialize
      self.equipped       = false
      self.consumable     = false
      self.used           = false
      self.number_of_uses = nil
      self.talkable       = false
    end

    def use(inventory = nil)
      'That item does not do anything...yet.'
    end

    def describe
      status_text =  name.upcase.colorize(:green)
      status_text << "\n#{description} \n".colorize(:white)
      status_text << "ATTACK: #{atk_lo}-#{atk_hi} \n".colorize(:white) unless atk_lo.nil?
      status_text << "TAKEABLE? #{takeable}\n".colorize(:white)
      status_text << "USEABLE? #{useable}\n".colorize(:white)
      status_text << "EQUIPPABLE? #{equippable}\n".colorize(:white)
      status_text << "CONSUMABLE? #{consumable}\n".colorize(:white)
      status_text << "NUMBER OF USES? #{number_of_uses}\n".colorize(:white) unless number_of_uses.nil?
      status_text << "TALKABLE? #{talkable}\n".colorize(:white)
      status_text << "\n"
    end
  end
end
