# lib/gemwarrior/player.rb
# Player creature

require_relative 'constants'
require_relative 'inventory'
require_relative 'creature'

module Gemwarrior
  class Player < Creature
    private

    @world = nil
    @xp = 0
    @current_location = nil
    
    def generate_name
      c1 = CHARUPPER_POOL[rand(0..25)]
      c2 = CHARLOWER_POOL[rand(0..25)]
      c3 = CHARLOWER_POOL[rand(0..25)]
      c4 = CHARLOWER_POOL[rand(0..25)]
      c5 = CHARLOWER_POOL[rand(0..25)]
      return "#{c1}#{c2}#{c3}#{c4}#{c5}"
    end
    
    def generate_desc
      desc = "Picked to do battle against a wizened madman for a shiny something or other for world-saving purposes, you're actually fairly able, as long as you've had breakfast first."
    end
    
    def generate_face
      FACE_DESC[rand(0..FACE_DESC.length-1)]
    end
    
    def generate_hands
      HANDS_DESC[rand(0..HANDS_DESC.length-1)]
    end
    
    def generate_mood
      MOOD_DESC[rand(0..MOOD_DESC.length-1)]
    end
    
    def generate_player_identity
      @name = generate_name
      @description = generate_desc
      @face = generate_face
      @hands = generate_hands
      @mood = generate_mood
    end
    
    public

    attr_reader :current_location
    
    def initialize(level = 1, xp = 0, hp_cur = 10, hp_max = 10, atk_lo = 1, atk_hi = 2, inventory = Inventory.new, rox = 0, world, current_location)
      # generates name, desc, face, hands, mood text
      generate_player_identity
      
      @level = level
      @xp = xp
      
      @hp_cur = hp_cur
      @hp_max = hp_max
      
      @atk_lo = atk_lo
      @atk_hi = atk_hi
      
      @inventory = inventory
      @rox = rox
      
      @world = world
      @current_location = current_location
    end

    def check_self
      puts "  Your face is #{@face}, hands are #{@hands}, and general mood is #{@mood}. Regardless, you know your name, which is *#{@name}*, so you've got that going for ya.\n"
    end

    def inventory
      @inventory.list
    end
    
    def inventory_add(id)
    
    end

    def move(direction)
    
    end
  end
end