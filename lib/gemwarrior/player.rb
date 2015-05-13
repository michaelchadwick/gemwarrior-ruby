# lib/gemwarrior/player.rb
# Player creature

require_relative 'constants'
require_relative 'inventory'
require_relative 'creature'

module Gemwarrior
  class Player < Creature
  
    private

    @stam_cur = 0
    @stam_max = 0
    @world = nil
    @xp = 0
    @cur_loc = nil
    
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

    attr_reader :name, :cur_loc, :hp_cur, :hp_max, :stam_cur, :stam_max
    
    def initialize(
      level = PLAYER_LEVEL_DEFAULT, 
      xp = PLAYER_XP_DEFAULT, 
      hp_cur = PLAYER_HP_CUR_DEFAULT, 
      hp_max = PLAYER_HP_MAX_DEFAULT, 
      stam_cur = PLAYER_STAM_CUR_DEFAULT, 
      stam_max = PLAYER_STAM_MAX_DEFAULT, 
      atk_lo = PLAYER_ATK_LO_DEFAULT, 
      atk_hi = PLAYER_ATK_HI_DEFAULT, 
      inventory = Inventory.new, 
      rox = 0, 
      world, 
      cur_loc
    )
      # generates name, desc, face, hands, mood text
      generate_player_identity
      
      @level = level
      @xp = xp
      
      @hp_cur = hp_cur
      @hp_max = hp_max
      @stam_cur = stam_cur
      @stam_max = stam_max
      
      @atk_lo = atk_lo
      @atk_hi = atk_hi
      
      @inventory = inventory
      @rox = rox
      
      @world = world
      @cur_loc = cur_loc
    end

    def check_self
      puts "  Your face is #{@face}, hands are #{@hands}, and general mood is #{@mood}. Regardless, you know your name, which is *#{@name}*, so you've got that going for ya.\n"
    end

    def inventory
      @inventory.list
    end
    
    def stamina_dec
      @stam_cur = @stam_cur - 1
    end    
    
    def inventory_add(id)
    
    end

    def move(direction)
    
    end
  end
end