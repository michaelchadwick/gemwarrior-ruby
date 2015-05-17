# lib/gemwarrior/monster.rb
# Monster creature

require_relative 'constants'
require_relative 'inventory'
require_relative 'creature'

module Gemwarrior
  class Monster < Creature
    include Entities::Monsters
    
    def initialize(
      id, 
      name = MOB_NAME_DEFAULT, 
      description = MOB_DESC_FAULT, 
      face = 'ugly', 
      hands = 'gnarled', 
      mood = 'unsurprisingly unchipper', 
      level = 1, 
      hp_cur = 5, 
      hp_max = 5, 
      atk_lo = 1, 
      atk_hi = 2, 
      inventory = Inventory.new, 
      rox = 1
    )
      @id = id
      @name = name
      @description = description
      @face = face
      @hands = hands
      @mood = mood
      
      @level = level
      @hp_cur = hp_cur
      @hp_max = hp_max
      
      @atk_lo = atk_lo
      @atk_hi = atk_hi
      
      @inventory = inventory
      @rox = rox
    end

  end
end
