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
                  :equipped
  end
end
