# lib/gemwarrior/entities/item.rb
# Item base class

require_relative 'entity'

module Gemwarrior
  class Item < Entity
    attr_accessor :atk_lo,
                  :atk_hi,
                  :takeable,
                  :useable,
                  :equippable,
                  :equipped,
                  :use

    def use(_inventory = nil)
      'That item does not do anything...yet.'
    end

    def describe
      status_text =  name.upcase.colorize(:green)
      status_text << "\n#{description} \n".colorize(:white)
      status_text << "ATTACK: #{atk_lo.to_s.rjust(2)}-#{atk_hi.to_s.rjust(2)} ".colorize(:white) unless atk_lo.nil?
      status_text << "TAKEABLE? #{takeable} ".colorize(:white)
      status_text << "USEABLE? #{useable} ".colorize(:white)
      status_text << "EQUIPPABLE? #{equippable} ".colorize(:white)
      status_text << "\n"
    end
  end
end
