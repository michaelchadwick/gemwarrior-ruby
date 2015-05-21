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
      self.id = id
      self.name = name
      self.description = description
      self.takeable = takeable
    end
    
    def is_takeable?
      takeable
    end
  end
end
