# lib/gemwarrior/item.rb
# Item base class

require_relative 'constants'

module Gemwarrior
  class Item
    attr_reader :id, :name, :description
    
    def initialize(
      id, 
      name = ITEM_NAME_DEFAULT, 
      description = ITEM_DESC_DEFAULT
    )
      @id = id
      @name = name
      @description = description
    end
  end
end