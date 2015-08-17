# lib/gemwarrior/entities/player.rb
# Player creature

require_relative 'creature'
require_relative '../battle'
require_relative '../game_options'
require_relative '../misc/formatting'
require_relative '../misc/name_generator'
require_relative '../misc/player_levels'
require_relative '../misc/wordlist'

module Gemwarrior
  class Player < Creature
    # CONSTANTS
    LEVEL_UP_TEXT       = '** LEVEL UP! **'
    REST_FULL_TEXT      = '** HMMMM **'
    REST_NOT_FULL_TEXT  = '** ZZZZZ **'
  
    include PlayerLevels
    include Formatting

    attr_accessor :stam_cur, :stam_max, :cur_coords, :special_abilities,
                  :monsters_killed, :items_taken, :movements_made,    
                  :rests_taken, :deaths

    def generate_name
      NameGenerator.new('fantasy').generate_name
    end

    def generate_face
      WordList.new('adjective').get_random_value
    end

    def generate_hands
      WordList.new('adjective').get_random_value
    end

    def generate_mood
      WordList.new('adjective').get_random_value
    end

    def check_self(show_pic = true)
      unless show_pic == false
        print_char_pic
      end

      weapon_slot = ''
      atk_lo = self.atk_lo
      atk_hi = self.atk_hi
      if has_weapon_equipped?
        weapon_slot = inventory.weapon.name
        atk_lo += inventory.weapon.atk_lo
        atk_hi += inventory.weapon.atk_hi
      else
        weapon_slot = '(unarmed)'
      end
      
      abilities = ''
      if special_abilities.empty?
        abilities = 'none...yet(?)'
      else
        abilities = Formatting::upstyle(special_abilities.collect { |x| x.to_s }).join(', ')
      end

      self_text =  "NAME      : #{self.name}\n"
      self_text << "LEVEL     : #{self.level}\n"
      self_text << "EXPERIENCE: #{self.xp}\n"
      self_text << "HIT POINTS: #{self.hp_cur}/#{self.hp_max}\n"
      self_text << "WEAPON    : #{weapon_slot}\n"
      self_text << "ATTACK    : #{atk_lo}-#{atk_hi}\n"
      self_text << "DEXTERITY : #{self.dexterity}\n"
      self_text << "DEFENSE   : #{self.defense}\n"
      self_text << "ABILITIES : #{abilities}\n"
      
      if GameOptions.data['debug_mode']
        self_text << "  POSITION  : #{self.cur_coords.values.to_a}\n"
        self_text << "  GOD_MODE  : #{GameOptions.data['god_mode']}\n"
        self_text << "  BEAST_MODE: #{GameOptions.data['beast_mode']}\n"
      end

      self_text << "\n"

      self_text << "[Your Story]\n#{self.description}"

      self_text << "\n\n"

      self_text << "[Current Status]\nBreathing, non-naked, with a #{self.face.colorize(:yellow)} face, #{self.hands.colorize(:yellow)} hands, and\nfeeling, generally, #{self.mood.colorize(:yellow)}."
      
      self_text << "\n"
    end

    def rest(world, tent_uses = 0, ensure_fight = false)
      if ensure_fight
        battle = Battle.new(world: world, player: self, monster: world.monsters[rand(0..world.monsters.length-1)].clone)
        result = battle.start(is_arena = false, is_event = true)
        if result.eql?('death')
          return 'death'
        else
          return
        end
      end

      cur_loc = world.location_by_coords(cur_coords)

      if cur_loc.should_spawn_monster?
        chance_of_ambush = rand(0..100)

        puts "chance_of_ambush: #{chance_of_ambush}" if GameOptions.data['debug_mode']

        if chance_of_ambush < 25
          battle = Battle.new(world: world, player: self, monster: cur_loc.monsters_abounding[rand(0..cur_loc.monsters_abounding.length-1)].clone)
          return battle.start(is_arena = false, is_event = true)
        end
      end

      # stats
      self.rests_taken += 1

      hours   = rand(1..23)
      minutes = rand(1..59)
      seconds = rand(1..59)

      hours_text = hours   == 1 ? 'hour'   : 'hours'
      mins_text  = minutes == 1 ? 'minute' : 'minutes'
      secs_text  = seconds == 1 ? 'second' : 'seconds'

      if tent_uses > 0
        if self.at_full_hp?
          return 'Despite feeling just fine, health-wise, you decide to set up camp for the ni--well, actually, after a few minutes you realize you don\'t need to sleep and pack things up again, ready to go.'
        else
          Animation::run(phrase: REST_NOT_FULL_TEXT)
          self.hp_cur = self.hp_max

          status_text = "You brandish the trusty magical canvas and, with a flick of the wrist, your home for the evening is set up. Approximately #{hours} #{hours_text}, #{minutes} #{mins_text}, and #{seconds} #{secs_text} later, you wake up, fully rested, ready for adventure."
          status_text << "\n>> You regain all of your hit points."

          return status_text
        end
      else
        if self.at_full_hp?
          Animation::run(phrase: REST_FULL_TEXT)
          return 'You sit down on the ground, make some notes on the back of your hand, test the air, and then return to standing, back at it all again.'
        else
          Animation::run(phrase: REST_NOT_FULL_TEXT)
          self.hp_cur = self.hp_cur.to_i + rand(10..15)
          self.hp_cur = self.hp_max if self.hp_cur > self.hp_max

          status_text = "You lie down somewhere quasi-flat and after a few moments, due to extreme exhaustion, you fall into a deep, yet troubled, slumber. Approximately #{hours} #{hours_text}, #{minutes} #{mins_text}, and #{seconds} #{secs_text} later, you wake up with a start. Upon getting to your feet you look around, notice you feel somewhat better, and wonder why you dreamt about #{WordList.new('noun-plural').get_random_value}."
          status_text << "\n>> You regain a few hit points."

          return status_text
        end
      end
    end

    def stamina_dec
      self.stam_cur = stam_cur - 1
    end

    def modify_name
      print 'Enter new name: '

      new_name = gets.chomp!

      if new_name.length <= 0
        return "You continue on as #{name}."
      elsif new_name.length < 3 || new_name.length > 10
        return "'#{new_name}' is an invalid length. Make it between 3 and 10 characters, please."
      else
        self.name = Formatting::upstyle(new_name)
        return "New name, '#{name}', accepted."
      end
    end

    def list_inventory
      inventory.list_contents
    end 

    def go(locations, direction)
      case direction
      when 'north', 'n'
        self.cur_coords = {
          x: cur_coords[:x], 
          y: cur_coords[:y]+1,
          z: cur_coords[:z]
        }
        direction_text = '^^^'
      when 'east', 'e'
        self.cur_coords = {
          x: cur_coords[:x]+1, 
          y: cur_coords[:y],
          z: cur_coords[:z]
        }
        direction_text = '>>>'
      when 'south', 's'
        self.cur_coords = {
          x: cur_coords[:x], 
          y: cur_coords[:y]-1,
          z: cur_coords[:z]
        }
        direction_text = 'vvv'
      when 'west', 'w'
        self.cur_coords = {
          x: cur_coords[:x]-1, 
          y: cur_coords[:y],
          z: cur_coords[:z]
        }
        direction_text = '<<<'
      end
      print_traveling_text(direction_text)

      # stats
      self.movements_made += 1
    end

    def attack(world, monster)
      battle = Battle.new(world: world, player: self, monster: monster)
      result = battle.start
      if result.eql?('death')
        return 'death'
      elsif result.eql?('exit')
        return 'exit'
      end
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

    def update_stats(trigger)
      old_player_level = PlayerLevels::check_level(self.xp)

      case
      when trigger[:reason].eql?(:monster)
        monster = trigger[:value]
        self.xp += monster.xp
        self.rox += monster.rox

        monster_items = monster.inventory.items
        unless monster_items.nil?
          self.inventory.items.concat monster_items unless monster_items.empty?
        end
      when trigger[:reason].eql?(:xp)
        self.xp += trigger[:value]
      when trigger[:reason].eql?(:level_bump)
        next_player_level = old_player_level + 1
        self.xp = PlayerLevels::get_level_stats(next_player_level)[:xp_start]
      end

      new_player_level = PlayerLevels::check_level(self.xp)

      if new_player_level > old_player_level
        Animation::run(phrase: LEVEL_UP_TEXT)
        new_stats = PlayerLevels::get_level_stats(new_player_level)

        self.level = new_stats[:level]
        puts "You are now level #{self.level}!"
        self.hp_cur = new_stats[:hp_max]
        self.hp_max = new_stats[:hp_max]
        puts "You now have #{self.hp_max} hit points!"
        self.stam_cur = new_stats[:stam_max]
        self.stam_max = new_stats[:stam_max]
        puts "You now have #{self.stam_max} stamina points!"
        self.atk_lo = new_stats[:atk_lo]
        self.atk_hi = new_stats[:atk_hi]
        puts "You now have an attack of #{self.atk_lo}-#{self.atk_hi}!"
        self.defense = new_stats[:defense]
        puts "You now have #{self.defense} defensive points!"
        self.dexterity = new_stats[:dexterity]
        puts "You now have #{self.dexterity} dexterity points!"
        unless new_stats[:special_abilities].nil?
          unless self.special_abilities.include?(new_stats[:special_abilities])
            self.special_abilities.push(new_stats[:special_abilities])
            puts "You learned a new ability: #{Formatting::upstyle(new_stats[:special_abilities])}!"
          end
        end
      end
    end

    def at_full_hp?
      self.hp_cur == self.hp_max
    end

    private

    def player_death
      puts 'Your actions have reduced you to death.'.colorize(:red)
      puts 'Somehow, however, your adventure does not end here. Instead, you are whisked back home via some magical force, a bit worse for the weary and somewhat poorer, but ALIVE!'.colorize(:yellow)
      return 'death'
    end

    def print_traveling_text(direction_text)
      Music::cue([
        { frequencies: 'C4', duration: 75 },
        { frequencies: 'D4', duration: 75 },
        { frequencies: 'E4', duration: 75 }
      ])
      Animation::run(phrase: "* #{direction_text} *", oneline: false)
    end

    def print_char_pic
      char_pic = ''
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
  end
end
