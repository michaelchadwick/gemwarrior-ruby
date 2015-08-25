# lib/gemwarrior/entities/item.rb
# Entity::Item base class

require_relative 'entity'

module Gemwarrior
  class Item < Entity
    attr_accessor :is_armor,
                  :is_weapon
  
    attr_reader   :use

    def initialize
      super
      
      self.is_armor   = false
      self.is_weapon  = false
    end

    def use(world)
      'That item does not do anything...yet.'
    end
  end
end
