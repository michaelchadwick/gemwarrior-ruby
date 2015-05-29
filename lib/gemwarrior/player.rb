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
    ERROR_GO_PARAM_INVALID      = 'The place in that direction is far, far, FAR too dangerous. You should try a different way.'
    ERROR_ATTACK_PARAM_INVALID  = 'That monster doesn\'t exist here or can\'t be attacked.'
    ERROR_ATTACK_OPTION_INVALID = 'That won\'t do anything against the monster.'
    
    attr_accessor :xp, :stam_cur, :stam_max, :atk_hi, :atk_lo, 
                  :defense, :dexterity, :rox, :cur_loc,
                  :god_mode
    
    def initialize(
      level, 
      xp, 
      hp_cur, 
      hp_max, 
      stam_cur, 
      stam_max, 
      atk_lo, 
      atk_hi, 
      defense,
      dexterity,  
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
      self.defense = defense
      self.dexterity = dexterity

      self.inventory = inventory
      self.rox = rox
      
      self.cur_loc = cur_loc
      
      self.god_mode = false
    end

    def check_self(show_pic = true)
      if show_pic
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
      self_text << "WPN : #{cur_weapon_name}\n"
      self_text << "LVL : #{level}\n"
      self_text << "XP  : #{xp}\n"
      self_text << "HP  : #{hp_cur}|#{hp_max}\n"
      self_text << "ATK : #{atk_lo}-#{atk_hi}\n"
      self_text << "DEF : #{defense}\n"
      self_text << "DEX : #{dexterity}\n"
      self_text << "GOD : #{god_mode}\n\n"
      self_text << "You check yourself. Currently breathing, wearing clothing, and with a few other specific characteristics: face is #{face}, hands are #{hands}, and general mood is #{mood}.\n"
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

    def attack(monster_name)
      if cur_loc.has_monster_to_attack?(monster_name)
        puts "You decide to attack the #{monster_name}"
        monster = cur_loc.monster_by_name(monster_name)
        puts "#{monster.name} cries out: #{monster.battlecry}"

        loop do
          if (monster.hp_cur <= 0)
            puts "You have defeated #{monster.name}!"
            puts "You have received #{monster.xp_to_give} XP!"
            puts "You have gained #{monster.rox} barterable rox!"
            update_player_stats(monster)
            cur_loc.remove_monster(monster.name)
            return 
          elsif (hp_cur <= 0 && !god_mode)
            puts "You are dead, slain by the #{monster.name}!"
            return
          end
          
          puts "\nYour options are 'fight', 'look', and 'run'."
          puts "P :: #{hp_cur} HP\n"
          puts "E :: #{monster.hp_cur} HP\n"
          
          if ((monster.hp_cur.to_f / monster.hp_max.to_f) < 0.10)
            puts "#{monster.name} is almost dead!\n"
          end
          
          puts 'What do you do?'
          cmd = gets.chomp
          
          case cmd
          when 'fight', 'f'
            puts "You attack #{monster.name}#{inventory.weapon}!"
            dmg = calculate_mob_damage
            if dmg > 0
              puts "You wound it for #{dmg} point(s)!"
              monster.take_damage(dmg)
            else
              puts "You miss entirely!"
            end
          when 'look', 'l'
            puts "#{monster.name}: #{monster.description}"
            puts "Its got some distinguishing features, too: face is #{monster.face}, hands are #{monster.hands}, and its general mood is #{monster.mood}."
          when 'run', 'r'
            escape = calculate_escape(monster)
            if escape
              monster.hp_cur = monster.hp_max
              puts "You successfully elude #{monster.name}!"
              return
            else
              puts "You were not able to run away! :-("
            end
          else
            puts ERROR_ATTACK_OPTION_INVALID
          end
        end
      else
        ERROR_ATTACK_PARAM_INVALID
      end
    end
    
    def cur_weapon_name
      unless inventory.weapon.nil?
        return " with your #{inventory.weapon.name}"
      end
    end
    
    def calculate_mob_damage
      miss = rand(0..100)
      if (miss < 15)
        0
      else
        rand(atk_lo..atk_hi)
      end
    end
    
    def calculate_escape(monster)
      if (dexterity > monster.dexterity)
        return true
      else
        dex_diff = monster.dexterity - dexterity
        rand_dex = rand(0..dex_diff)
        if rand_dex % 2 > 0
          return true
        else
          return false
        end
      end
    end
  
    private
   
    def update_player_stats(monster)
      self.xp = xp + monster.xp_to_give
      self.rox = rox + monster.rox
    end
    
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
