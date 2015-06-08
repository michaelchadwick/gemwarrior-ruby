# lib/gemwarrior/entities/player.rb
# Player creature

require_relative 'creature'
require_relative '../battle'

module Gemwarrior
  class Player < Creature
    # CONSTANTS
    ## CHARACTER ATTRIBUTES
    CHAR_UPPER_POOL       = (65..90).map{ |i| i.chr }
    CHAR_LOWER_POOL       = (97..122).map{ |i| i.chr }
    CHAR_LOWER_VOWEL_POOL = ['a','e','i','o','u','y']
    
    FACE_DESC   = ['smooth', 'tired', 'ruddy', 'moist', 'shocked', 'handsome', '5 o\'clock-shadowed']
    HANDS_DESC  = ['worn', 'balled into fists', 'relaxed', 'cracked', 'tingly', 'mom\'s spaghetti']
    MOOD_DESC   = ['calm', 'excited', 'depressed', 'tense', 'lackadaisical', 'angry', 'positive']
    
    attr_accessor :stam_cur, :stam_max, :cur_coords, :god_mode
    
    def initialize(options)
      self.name         = generate_name
      self.description  = options.fetch(:description)
      
      self.face         = generate_face
      self.hands        = generate_hands
      self.mood         = generate_mood
      
      self.level        = options.fetch(:level)
      self.xp           = options.fetch(:xp)
      self.hp_cur       = options.fetch(:hp_cur)
      self.hp_max       = options.fetch(:hp_max)
      self.atk_lo       = options.fetch(:atk_lo)
      self.atk_hi       = options.fetch(:atk_hi)

      self.defense      = options.fetch(:defense)
      self.dexterity    = options.fetch(:dexterity)
      
      self.inventory    = Inventory.new
      self.rox          = options.fetch(:rox)

      self.stam_cur     = options.fetch(:stam_cur)
      self.stam_max     = options.fetch(:stam_max)
      self.cur_coords   = options.fetch(:cur_coords)

      self.god_mode     = false
    end

    def check_self(show_pic = true)
      unless show_pic == false
        print_char_pic
      end
      
      cur_weapon_name = ''
      if inventory.weapon.nil?
        cur_weapon_name = '(unarmed)'
      else
        cur_weapon_name = inventory.weapon.name
        self.atk_lo = inventory.weapon.atk_lo
        self.atk_hi = inventory.weapon.atk_hi
      end

      self_text =  "NAME: #{name}\n"
      self_text =  "XY  : #{cur_coords.values.to_a}\n"
      self_text << "WPN : #{cur_weapon_name}\n"
      self_text << "LVL : #{level}\n"
      self_text << "XP  : #{xp}\n"
      self_text << "HP  : #{hp_cur}|#{hp_max}\n"
      self_text << "ATK : #{atk_lo}-#{atk_hi}\n"
      self_text << "DEX : #{dexterity}\n"
      self_text << "DEF : #{defense}\n"
      self_text << "GOD : #{god_mode}\n\n"
      
      self_text << "#{description}\n\n"
      
      self_text << "Current status - breathing, wearing clothing, and with a few other specific characteristics: face is #{face}, hands are #{hands}, and general mood is #{mood}.\n"
    end
    
    def rest
      hours = rand(1..23)
      minutes = rand(1..59)
      seconds = rand(1..59)
    
      hours_text = hours == 1 ? "hour" : "hours"
      mins_text = minutes == 1 ? "minute" : "minutes"
      secs_text = seconds == 1 ? "second" : "seconds"
    
      self.hp_cur = hp_max
    
      return "You lie down somewhere quasi-flat and after a few moments, due to extreme exhaustion, you fall into a deep slumber. Approximately #{hours} #{hours_text}, #{minutes} #{mins_text}, and #{seconds} #{secs_text} later, you wake up with a start, look around you, notice nothing in particular, and get back up, ready to go again."
    end

    def stamina_dec
      self.stam_cur = stam_cur - 1
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

    def go(locations, direction)
      case direction
      when 'north', 'n'
        self.cur_coords = {:x => cur_coords[:x],    :y => cur_coords[:y]+1}
      when 'east', 'e'
        self.cur_coords = {:x => cur_coords[:x]+1,  :y => cur_coords[:y]}
      when 'south', 's'
        self.cur_coords = {:x => cur_coords[:x],    :y => cur_coords[:y]-1}
      when 'west', 'w'
        self.cur_coords = {:x => cur_coords[:x]-1,  :y => cur_coords[:y]}
      end
      print_traveling_text
    end

    def attack(world, monster)
      battle = Battle.new({:world => world, :player => self, :monster => monster})
      battle.start
    end
    
    def cur_weapon_name
      unless inventory.weapon.nil?
        return " with your #{inventory.weapon.name}"
      end
    end

    private
    
    # TRAVEL    
    def print_traveling_text
      loc = Thread.new do
        print "* "
        print "#{Matrext::process({ :phrase => ">>>", :sl => true })}"
        print " *\n"
      end
      return loc.join
    end
    
    # CHARACTER
    def print_char_pic
      char_pic = ""
      char_pic << "************\n"
      char_pic << "*    ()    *\n"
      char_pic << "*  \\-||-/  *\n"
      char_pic << "*    --    *\n"
      char_pic << "*    ||    *\n"
      char_pic << "*   _||_   *\n"
      char_pic << "************\n"
      puts char_pic
    end

    def print_battle_line
      puts '**************************************'
    end

    # INIT
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
    
    def generate_face
      FACE_DESC[rand(0..FACE_DESC.length-1)]
    end
    
    def generate_hands
      HANDS_DESC[rand(0..HANDS_DESC.length-1)]
    end
    
    def generate_mood
      MOOD_DESC[rand(0..MOOD_DESC.length-1)]
    end
  end
end
