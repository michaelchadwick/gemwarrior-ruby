# lib/gemwarrior/player.rb
# Player creature

require 'pry'

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

    attr_reader   :level, :xp, :cur_loc, :hp_cur, :hp_max, :stam_cur, :stam_max
    attr_accessor :name
    
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
      
      @cur_loc = cur_loc
    end

    def check_self
      puts "You check yourself. Currently breathing, wearing clothing, and with a few specific characteristics: face is #{@face}, hands are #{@hands}, and general mood is #{@mood}."
    end

    def stamina_dec
      @stam_cur = @stam_cur - 1
    end

    def modify_name(name)
      if name.length < 3 || name.length > 10
        puts "'#{name.chomp}' is an invalid length. Make it between 3 and 10 characters, please."
      else
        name.downcase!
        name[0].upcase!
        name.chomp!
        puts "New name, '#{name}', accepted."
        @name = name.chomp
      end
      return nil
    end
    
    def list_inventory
      @inventory.list_contents
    end 
    
    def inventory_add(id)
      
    end

    def loc_by_id(locations, id)
      locations.each do |loc|
        if loc.id.to_i.equal? id
          return loc
        end
      end
      return nil
    end
    
    def can_move?(direction)
      @cur_loc.has_loc_to_the?(direction)
    end
    
    def go(locations, direction)
      unless direction.nil?
        if can_move?(direction)
          new_loc_id = @cur_loc.locs_connected[direction.to_sym]
          @cur_loc = loc_by_id(locations, new_loc_id)
          print @cur_loc.describe
        else
          puts LOC_GO_NADA
        end
      end
    end
  end
end