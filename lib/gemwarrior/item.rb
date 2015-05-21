# lib/gemwarrior/item.rb
# Item base class

module Gemwarrior
  class Item
    attr_accessor :id, :name, :description, :takeable
    
    def initialize(
      id, 
      name, 
      description,
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
