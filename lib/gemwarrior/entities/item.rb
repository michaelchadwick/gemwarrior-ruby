# lib/gemwarrior/entities/item.rb
# Item base class

require_relative 'entity'

module Gemwarrior
  class Item < Entity
    attr_accessor :id, :name, :description, 
                  :atk_lo, :atk_hi, :takeable, :equippable, :equipped
    
    def initialize(options)
      self.id           = options[:id]
      self.name         = options[:name]
      self.description  = options[:description]
      self.atk_lo       = options[:atk_lo]
      self.atk_hi       = options[:atk_hi]
      self.takeable     = options[:takeable]
      self.equippable   = options[:equippable]
      self.equipped     = options[:equipped]
    end
  end
end
