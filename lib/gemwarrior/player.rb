# lib/inventory.rb

require_relative 'constants'
require_relative 'inventory'

module Gemwarrior
  class Player
  
    def initialize
      c1 = CHARUPPER_POOL[rand(0..25)]
      c2 = CHARLOWER_POOL[rand(0..25)]
      c3 = CHARLOWER_POOL[rand(0..25)]
      c4 = CHARLOWER_POOL[rand(0..25)]
      c5 = CHARLOWER_POOL[rand(0..25)]
      @name = "#{c1}#{c2}#{c3}#{c4}#{c5}"
      @face = FACE_DESC[rand(0..FACE_DESC.length-1)]
      @hands = HANDS_DESC[rand(0..HANDS_DESC.length-1)]
      @mood = MOOD_DESC[rand(0..MOOD_DESC.length-1)]
      @inventory = Inventory.new
    end
    
    def check_self
      puts "  Your face is #{@face}, hands are #{@hands}, and general mood is #{@mood}. Regardless, you know your name, which is *#{@name}*, so you've got that going for ya.\n"
    end
    
    def inventory
      @inventory.list
    end
    
    def move(direction)
    
    end
  end
end