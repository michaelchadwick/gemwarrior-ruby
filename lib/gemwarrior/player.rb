# lib/gemwarrior/player.rb
# Player creature

require 'matrext'

require_relative 'constants'
require_relative 'inventory'
require_relative 'creature'

module Gemwarrior
  class Player < Creature
    private
    
    def generate_name
      name = []
      letter_max = rand(5..10)
      name[0] = CHAR_UPPER_POOL[rand(0..25)]
      name[1] = CHAR_LOWER_VOWEL_POOL[rand(0..5)]
      2.upto(letter_max) do |i|
        name[i] = CHAR_LOWER_POOL[rand(0..25)]
      end
      return name.join
    end
    
    def generate_desc
      PLYR_DESC_DEFAULT
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

    attr_reader :name, :description, :cur_loc, :hp_cur, :hp_max, :stam_cur, :stam_max
    
    def initialize(
      level = PLYR_LEVEL_DEFAULT, 
      xp = PLYR_XP_DEFAULT, 
      hp_cur = PLYR_HP_CUR_DEFAULT, 
      hp_max = PLYR_HP_MAX_DEFAULT, 
      stam_cur = PLYR_STAM_CUR_DEFAULT, 
      stam_max = PLYR_STAM_MAX_DEFAULT, 
      atk_lo = PLYR_ATK_LO_DEFAULT, 
      atk_hi = PLYR_ATK_HI_DEFAULT, 
      inventory = Inventory.new, 
      rox = PLYR_ROX_DEFAULT, 
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
      puts "You check yourself: face is #{@face}, hands are #{@hands}, and general mood is #{@mood}."
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