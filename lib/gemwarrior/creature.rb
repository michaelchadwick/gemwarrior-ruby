# lib/creature.rb

require_relative 'constants'
require_relative 'inventory'

module Gemwarrior
  class Creature
    private
    
    @id = nil
    @name = 'Creature'
    @face = 'calm'
    @hands = 'smooth'
    @mood = 'happy'
    
    @level = 1
    @hp_cur = 10
    @hp_max = 10

    @atk_lo = 1
    @atk_hi = 3
    
    @rox = 1
    @inventory = []

    public
    
    def initialize(id, name, face, hands, mood, level = 1, hp_cur = 10, hp_max = 10, atk_lo = 1, atk_hi = 3, inventory = Inventory.new, rox = 1)
      @id = id
      @name = name
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