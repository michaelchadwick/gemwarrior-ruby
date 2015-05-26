# lib/gemwarrior/player.rb
# Player creature

require_relative 'creature'

module Gemwarrior
  class Player < Creature
    # CONSTANTS
    ## ATTRIBUTE POOLS
    CHAR_UPPER_POOL = (65..90).map{ |i| i.chr }
    CHAR_LOWER_POOL = (97..122).map{ |i| i.chr }
    CHAR_LOWER_VOWEL_POOL = ['a','e','i','o','u','y']

    FACE_DESC  = ['smooth', 'tired', 'ruddy', 'moist', 'shocked', 'handsome', '5 o\'clock-shadowed']
    HANDS_DESC = ['worn', 'balled into fists', 'relaxed', 'cracked', 'tingly', 'mom\'s spaghetti']
    MOOD_DESC  = ['calm', 'excited', 'depressed', 'tense', 'lackadaisical', 'angry', 'positive']
    
    ## PLAYER DEFAULTS
    PLYR_DESC_DEFAULT = 'Picked to do battle against a wizened madman for a shiny something or other for world-saving purposes, you\'re actually fairly able, as long as you\'ve had breakfast first.'
    
    ## ERRORS
    ERROR_GO_PARAM_INVALID = 'The place in that direction is far, far, FAR too dangerous. You should try a different way.'
    
    attr_accessor :xp, :stam_cur, :stam_max, :atk_hi, :atk_lo, :rox, :cur_loc
    
    def initialize(
      level, 
      xp, 
      hp_cur, 
      hp_max, 
      stam_cur, 
      stam_max, 
      atk_lo, 
      atk_hi, 
      inventory, 
      rox, 
      cur_loc
    )
      generate_player_identity
      
      self.level = level
      self.xp = xp
      
      self.hp_cur = hp_cur
      self.hp_max = hp_max
      self.stam_cur = stam_cur
      self.stam_max = stam_max
      
      self.atk_lo = atk_lo
      self.atk_hi = atk_hi
      
      self.inventory = inventory
      self.rox = rox
      
      self.cur_loc = cur_loc
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
      stam_cur = stam_cur - 1
    end

    def modify_name
      print "Enter new name: "
      new_name = gets.chomp!
      if new_name.length < 3 || new_name.length > 10
        return "'#{new_name}' is an invalid length. Make it between 3 and 10 characters, please."
      else
        name_to_add = ""
        name_to_add << new_name[0].upcase
        name_to_add << new_name[1..new_name.length-1].downcase
        self.name = name_to_add
        return "New name, '#{name}', accepted."
      end
      return nil
    end
    
    def list_inventory
      inventory.list_contents
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
      cur_loc.has_loc_to_the?(direction)
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
          new_loc_id = cur_loc.locs_connected[direction.to_sym]
          self.cur_loc = loc_by_id(locations, new_loc_id)
          print_traveling_text
          cur_loc.checked_for_monsters = false
          cur_loc.describe
        else
          ERROR_GO_PARAM_INVALID
        end
      end
    end
  
    def attack(monster)
      'You can\'t attack anything yet, because you\'re too weak.'
    end
  
    private
    
    def print_traveling_text
      loc = Thread.new do
        print "* "
        print "#{Matrext::process({ :phrase => ">>>", :sl => true })}"
        print " *\n"
      end
      loc.join
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
      self.name = generate_name
      self.description = generate_desc
      self.face = generate_face
      self.hands = generate_hands
      self.mood = generate_mood
    end
  end
end
