# lib/gemwarrior/entities/player.rb
# Player creature

require_relative 'creature'
require_relative '../battle'
require_relative '../misc/name_generator'
require_relative '../misc/player_levels'
require_relative '../misc/wordlist'

module Gemwarrior
  class Player < Creature
    include PlayerLevels

    attr_accessor :stam_cur, :stam_max, :cur_coords, 
                  :god_mode, :beast_mode, :use_wordnik

    def initialize(options)
      self.name         = generate_name
      self.description  = options.fetch(:description)
      self.use_wordnik  = options.fetch(:use_wordnik)
      
      self.face         = generate_face(use_wordnik)
      self.hands        = generate_hands(use_wordnik)
      self.mood         = generate_mood(use_wordnik)

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
      
      self.god_mode     = options.fetch(:god_mode)
      self.beast_mode   = options.fetch(:beast_mode)      
    end

    def check_self(debug_mode = false, show_pic = true)
      unless show_pic == false
        print_char_pic
      end
      
      weapon_slot = ''
      if has_weapon_equipped?
        weapon_slot = inventory.weapon.name
        self.atk_lo = inventory.weapon.atk_lo
        self.atk_hi = inventory.weapon.atk_hi
      else
        weapon_slot = '(unarmed)'
      end

      self_text =  "NAME      : #{self.name}\n"
      self_text << "POSITION  : #{self.cur_coords.values.to_a}\n"
      self_text << "WEAPON    : #{weapon_slot}\n"
      self_text << "LEVEL     : #{self.level}\n"
      self_text << "EXPERIENCE: #{self.xp}\n"
      self_text << "HIT POINTS: #{self.hp_cur}/#{self.hp_max}\n"
      self_text << "ATTACK    : #{self.atk_lo}-#{self.atk_hi}\n"
      self_text << "DEXTERITY : #{self.dexterity}\n"
      self_text << "DEFENSE   : #{self.defense}\n"
      if debug_mode
        self_text << "GOD_MODE  : #{self.god_mode}\n"
        self_text << "BEAST_MODE: #{self.beast_mode}\n"
      end
      
      self_text << "\n#{self.description}\n\n"
      
      self_text << "Current status - breathing, wearing clothing, and with a few other specific characteristics: face is #{self.face}, hands are #{self.hands}, and general mood is #{self.mood}.\n"
    end
    
    def rest(world)
      cur_loc = world.location_by_coords(cur_coords)

      if cur_loc.has_monster?
        chance_of_ambush = rand(0..100)
      
        if chance_of_ambush < 25
          battle = Battle.new({:world => world, :player => self, :monster => cur_loc.monsters_abounding[rand(0..cur_loc.monsters_abounding.length-1)]})
          return battle.start(is_arena = false, is_event = true)
        end
      end

      hours = rand(1..23)
      minutes = rand(1..59)
      seconds = rand(1..59)
  
      hours_text = hours == 1 ? "hour" : "hours"
      mins_text = minutes == 1 ? "minute" : "minutes"
      secs_text = seconds == 1 ? "second" : "seconds"
      
      Animation::run({:phrase => '** Zzzzz **'})
      
      if self.inventory.has_item?('tent') || world.location_by_coords(cur_coords).has_item?('tent')
        self.hp_cur = self.hp_max
        
        return "You brandish your trusty magical canvas, and with a flick of the wrist your home for the evening is set up. Approximately #{hours} #{hours_text}, #{minutes} #{mins_text}, and #{seconds} #{secs_text} later, you wake up, fully rested, ready for adventure."
      else
        self.hp_cur = self.hp_cur.to_i + rand(10..15)
        self.hp_cur = self.hp_max if self.hp_cur > self.hp_max
        
        return "You lie down somewhere quasi-flat and after a few moments, due to extreme exhaustion, you fall into a deep, yet troubled, slumber. Approximately #{hours} #{hours_text}, #{minutes} #{mins_text}, and #{seconds} #{secs_text} later, you wake up with a start. Upon getting to your feet you look around, notice you feel somewhat better, and wonder why you dreamt about #{WordList.new(world.use_wordnik, 'noun-plural').get_random_value}."
      end
    end

    def stamina_dec
      self.stam_cur = stam_cur - 1
    end

    def modify_name
      print "Enter new name: "

      new_name = gets.chomp!

      if new_name.length <= 0
        return "You continue on as #{name}."
      elsif new_name.length < 3 || new_name.length > 10
        return "'#{new_name}' is an invalid length. Make it between 3 and 10 characters, please."
      else
        name_to_add = ""
        name_to_add << new_name[0].upcase
        name_to_add << new_name[1..new_name.length-1].downcase
        self.name = name_to_add
        return "New name, '#{name}', accepted."
      end
    end
    
    def list_inventory
      inventory.list_contents
    end 

    def go(locations, direction, sound)
      case direction
      when 'north', 'n'
        self.cur_coords = {
          :x => cur_coords[:x], 
          :y => cur_coords[:y]+1,
          :z => cur_coords[:z]
        }
        direction_text = '^^^'
      when 'east', 'e'
        self.cur_coords = {
          :x => cur_coords[:x]+1, 
          :y => cur_coords[:y],
          :z => cur_coords[:z]
        }
        direction_text = '>>>'
      when 'south', 's'
        self.cur_coords = {
          :x => cur_coords[:x], 
          :y => cur_coords[:y]-1,
          :z => cur_coords[:z]
        }
        direction_text = 'vvv'
      when 'west', 'w'
        self.cur_coords = {
          :x => cur_coords[:x]-1, 
          :y => cur_coords[:y],
          :z => cur_coords[:z]
        }
        direction_text = '<<<'
      end
      print_traveling_text(direction_text, sound)
    end

    def attack(world, monster)
      battle = Battle.new({:world => world, :player => self, :monster => monster})
      battle.start
    end
    
    def has_weapon_equipped?
      self.inventory.weapon
    end
    
    def cur_weapon_name
      if has_weapon_equipped?
        return " with your #{inventory.weapon.name}"
      else
        return nil
      end
    end
    
    def take_damage(dmg)
      self.hp_cur = self.hp_cur - dmg.to_i
      
      if hp_cur <= 0
        player_death
      end
    end
    
    def heal_damage(dmg)
      self.hp_cur = self.hp_cur + dmg.to_i
      if self.hp_cur > self.hp_max
        self.hp_cur = self.hp_max
      end
    end

    private

    def player_death
      puts 'Your actions have reduced you to death.'.colorize(:red)
      puts 'Your adventure ends here. Try again next time!'.colorize(:red)
      exit(0)
    end
    
    # TRAVEL    
    def print_traveling_text(direction_text, sound)
      Animation::run({:oneline => false, :phrase => "* #{direction_text} *"})
      if sound
        Music::cue([
          {:freq_or_note => 'C3,E3'}
        ])
      end
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
      NameGenerator.new('fantasy').generate_name
    end
    
    def generate_face(use_wordnik)
      face_descriptors = WordList.new(use_wordnik, 'adjective')
      face_descriptors.get_random_value
    end
    
    def generate_hands(use_wordnik)
      hand_descriptors = WordList.new(use_wordnik, 'adjective')
      hand_descriptors.get_random_value
    end
    
    def generate_mood(use_wordnik)
      mood_descriptors = WordList.new(use_wordnik, 'adjective')
      mood_descriptors.get_random_value
    end
  end
end
