# lib/gemwarrior/monster.rb
# Monster creature

require_relative 'creature'

module Gemwarrior
  class Monster < Creature
    attr_accessor :xp, :atk_hi, :atk_lo, :rox
  
    def initialize(
      id, 
      name, 
      description, 
      face,
      hands, 
      mood, 
      level, 
      hp_cur, 
      hp_max, 
      atk_lo, 
      atk_hi, 
      inventory, 
      rox
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
