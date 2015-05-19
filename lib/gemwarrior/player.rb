# lib/gemwarrior/player.rb
# Player creature

require_relative 'constants'
require_relative 'inventory'
require_relative 'creature'

module Gemwarrior
  class Player < Creature
    private
    
    def print_traveling_text
      traveling_text =  "******************\n"
      traveling_text << "   Traveling...   \n"
      traveling_text << "******************\n"
      puts traveling_text
    end
    
    def print_char_pic
      char_pic = ""
      char_pic << "**********\n"
      char_pic << "*   ()   *\n"
      char_pic << "* \\-||-/ *\n"
      char_pic << "*   --   *\n"
      char_pic << "*   ||   *\n"
      char_pic << "*  _||_  *\n"
      char_pic << "**********\n"
      puts char_pic
    end

    include AttributePools
    include Errors

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

    attr_reader   :level, :xp, :cur_loc, :hp_cur, :hp_max, :stam_cur, :stam_max, :inventory
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
      print_char_pic
      return "You check yourself. Currently breathing, wearing clothing, and with a few specific characteristics: face is #{@face}, hands are #{@hands}, and general mood is #{@mood}.\n"
    end
    
    def rest
      hours = rand(1..23)
      minutes = rand(1..59)
      seconds = rand(1..59)
    
      hours_text = hours == 1 ? "hour" : "hours"
      mins_text = minutes == 1 ? "minute" : "minutes"
      secs_text = seconds == 1 ? "second" : "seconds"
    
      return "You lie down somewhere quasi-flat and after a few moments, due to extreme exhaustion, you fall into a deep slumber. Approximately #{hours} #{hours_text}, #{minutes} #{mins_text}, and #{seconds} #{secs_text} later, you wake up with a start, look around you, notice nothing in particular, and get back up, ready to go again."
    end

    def stamina_dec
      @stam_cur = @stam_cur - 1
    end

    def modify_name
      print "Enter new name: "
      name = gets.chomp!
      if name.length < 3 || name.length > 10
        return "'#{name}' is an invalid length. Make it between 3 and 10 characters, please."
      else
        new_name = ""
        new_name << name[0].upcase
        new_name << name[1..name.length-1].downcase
        @name = new_name
        return "New name, '#{new_name}', accepted."
      end
      return nil
    end
    
    def list_inventory
      @inventory.list_contents
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
      case direction
      when "n"
        direction = "north"
      when "e"
        direction = "east"
      when "s"
        direction = "south"
      when "w"
        direction = "west"
      end
      unless direction.nil?
        if can_move?(direction)
          new_loc_id = @cur_loc.locs_connected[direction.to_sym]
          @cur_loc = loc_by_id(locations, new_loc_id)
          print_traveling_text
          @cur_loc.describe
        else
          ERROR_GO_DIR_INVALID
        end
      end
    end
  end
end
