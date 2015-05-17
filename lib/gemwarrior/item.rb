# lib/gemwarrior/item.rb
# Item base class

require_relative 'constants'

module Gemwarrior
  class Item
    include Entities::Items
    
    attr_reader :id, :name, :description, :takeable
    
    def initialize(
      id, 
      name = ITEM_NAME_DEFAULT, 
      description = ITEM_DESC_DEFAULT,
      takeable
    )
      @id = id
      @name = name
      @description = description
      @takeable = takeable
    end
    
    def is_takeable?
      @takeable
    end
  end
end
