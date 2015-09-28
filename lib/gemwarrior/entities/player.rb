# lib/gemwarrior/entities/player.rb
# Player creature

require_relative 'creature'
require_relative '../battle'
require_relative '../game_assets'
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

    attr_accessor :cur_coords,
                  :special_abilities,
                  :monsters_killed,
                  :bosses_killed,
                  :items_taken,
                  :movements_made,
                  :rests_taken,
                  :deaths

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

      weapon_slot     = '(unarmed)'
      armor_slot      = '(unarmored)'
      base_atk_lo     = self.atk_lo
      base_atk_hi     = self.atk_hi
      base_defense    = self.defense
      base_dexterity  = self.dexterity
      net_atk_lo      = nil
      net_atk_hi      = nil
      net_defense     = nil
      net_dexterity   = nil

      # juice the weapon display
      if has_weapon_equipped?
        weapon_slot = self.inventory.weapon.name
        net_atk_lo = base_atk_lo + self.inventory.weapon.atk_lo
        net_atk_hi = base_atk_hi + self.inventory.weapon.atk_hi
        net_dexterity = self.dexterity + self.inventory.weapon.dex_mod
      end

      # juice the armor display
      if has_armor_equipped?
        armor_slot = inventory.armor.name
        net_defense = base_defense + inventory.armor.defense
      end

      abilities = ''
      if special_abilities.empty?
        abilities = " none...yet(?)\n"
      else
        abilities << "\n"
        special_abilities.each do |sp|
          abilities << "  #{Formatting.upstyle(sp.to_s).ljust(15).colorize(:yellow)}: #{PlayerLevels.get_ability_description(sp)}\n"
        end
      end

      self_text =  "\n"
      self_text << "NAME      : #{self.name.colorize(:green)}\n"
      self_text << "LEVEL     : #{self.level}\n"
      self_text << "EXPERIENCE: #{self.xp}\n"
      self_text << "HIT POINTS: #{self.hp_cur}/#{self.hp_max}\n"
      self_text << "WEAPON    : #{weapon_slot}\n"
      self_text << "ARMOR     : #{armor_slot}\n"
      self_text << "ATTACK    : #{base_atk_lo}-#{base_atk_hi}"
      self_text << " (#{net_atk_lo}-#{net_atk_hi} w/ #{weapon_slot})".colorize(:yellow) unless net_atk_lo.nil?
      self_text << "\n"
      self_text << "DEFENSE   : #{base_defense}"
      self_text << " (#{net_defense} w/ #{armor_slot})".colorize(:yellow) unless net_defense.nil?
      self_text << "\n"
      self_text << "DEXTERITY : #{self.dexterity}"
      self_text << " (#{net_dexterity} w/ #{weapon_slot})".colorize(:yellow) unless net_dexterity.nil?
      self_text << "\n"
      self_text << "ABILITIES :"
      self_text << "#{abilities}"
      self_text << "INVENTORY : #{self.inventory.contents}\n"
      
      if GameOptions.data['debug_mode']
        self_text << "\n"
        self_text << "[DEBUG STUFF]\n"
        self_text << ">> POSITION       : #{self.cur_coords.values.to_a}\n"
        self_text << ">> GOD_MODE       : #{GameOptions.data['god_mode']}\n"
        self_text << ">> BEAST_MODE     : #{GameOptions.data['beast_mode']}\n"
        self_text << ">> MONSTERS_KILLED: #{self.monsters_killed}\n"
        self_text << ">> BOSSES_KILLED  : #{self.bosses_killed}\n"
        self_text << ">> ITEMS_TAKEN    : #{self.items_taken}\n"
        self_text << ">> MOVEMENTS_MADE : #{self.movements_made}\n"
        self_text << ">> RESTS_TAKEN    : #{self.rests_taken}\n"
        self_text << ">> DEATHS         : #{self.deaths}\n"
      end

      self_text << "\n"

      self_text << "[#{"Your Story".colorize(:yellow)}]\n#{self.description}"

      self_text << "\n\n"

      self_text << "[#{"Current Status".colorize(:yellow)}]\nBreathing, non-naked, with a #{self.face.colorize(:yellow)} face, #{self.hands.colorize(:yellow)} hands, and feeling, generally, #{self.mood.colorize(:yellow)}."
      
      self_text << "\n"
    end

    def rest(world, tent_uses = 0, ensure_fight = false)
      if ensure_fight
        battle = Battle.new(world: world, player: self, monster: GameMonsters.data[rand(0..GameMonsters.data.length-1)].clone)
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
          Animation.run(phrase: REST_FULL_TEXT)
          return 'Despite feeling just fine, health-wise, you decide to set up camp for the ni--well, actually, after a few minutes you realize you don\'t need to sleep and pack things up again, ready to go.'
        else
          Animation.run(phrase: REST_NOT_FULL_TEXT)
          self.hp_cur = self.hp_max

          status_text = "You brandish the trusty magical canvas and, with a flick of the wrist, your home for the evening is set up. Approximately #{hours} #{hours_text}, #{minutes} #{mins_text}, and #{seconds} #{secs_text} later, you wake up, fully rested, ready for adventure.\n"
          status_text << ">> You regain all of your hit points.".colorize(:green)

          return status_text
        end
      else
        if self.at_full_hp?
          Animation.run(phrase: REST_FULL_TEXT)
          return 'You sit down on the ground, make some notes on the back of your hand, test the air, and then return to standing, back at it all again.'
        else
          Animation.run(phrase: REST_NOT_FULL_TEXT)
          self.hp_cur = self.hp_cur.to_i + rand(3..5)
          self.hp_cur = self.hp_max if self.hp_cur > self.hp_max

          status_text = "You lie down somewhere quasi-flat and after a few moments, due to extreme exhaustion, you fall into a deep, yet troubled, slumber. Approximately #{hours} #{hours_text}, #{minutes} #{mins_text}, and #{seconds} #{secs_text} later, you wake up with a start. Upon getting to your feet you look around, notice you feel somewhat better, and wonder why you dreamt about #{WordList.new('noun-plural').get_random_value}.\n"
          status_text << ">> You regain a few hit points.".colorize(:green)

          return status_text
        end
      end
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

    def go(world, direction)
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
      world.location_by_coords(self.cur_coords).visited = true
      print_traveling_text(direction_text)

      # stats
      self.movements_made += 1
    end

    def attack(world, monster, is_ambush = false)
      if monster.is_dead
        { type: 'message', data: 'That monster is now dead forever and cannot be attacked. You must have done them a good one.' }
      else
        battle = Battle.new(world: world, player: self, monster: monster)
        result = battle.start(false, is_ambush)
        if result.eql?('death')
          return 'death'
        elsif result.eql?('exit')
          return 'exit'
        else
          return result
        end
      end
    end

    def has_weapon_equipped?
      self.inventory.weapon
    end

    def has_armor_equipped?
      self.inventory.armor
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
        return player_death
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
        next_player_level = old_player_level + trigger[:value]
        self.xp = PlayerLevels::get_level_stats(next_player_level)[:xp_start]
      end

      new_player_level = PlayerLevels::check_level(self.xp)

      # how many levels did we go up, if any?
      level_climb = new_player_level - old_player_level

      if level_climb >= 1
        level_to_get = old_player_level

        level_climb.times do
          level_to_get += 1
          Audio.play_synth(:player_level_up)
          Animation.run(phrase: LEVEL_UP_TEXT)
          new_stats = PlayerLevels::get_level_stats(level_to_get)

          self.level = new_stats[:level]
          puts "You are now level #{self.level.to_s.colorize(:green)}!"
          self.hp_cur = new_stats[:hp_max]
          self.hp_max = new_stats[:hp_max]
          puts "You now have #{self.hp_max.to_s.colorize(:green)} hit points!"
          self.atk_lo = new_stats[:atk_lo]
          self.atk_hi = new_stats[:atk_hi]
          puts "You now have an attack of #{self.atk_lo.to_s.colorize(:green)}-#{self.atk_hi.to_s.colorize(:green)}!"
          self.defense = new_stats[:defense]
          puts "You now have #{self.defense.to_s.colorize(:green)} defensive points!"
          self.dexterity = new_stats[:dexterity]
          puts "You now have #{self.dexterity.to_s.colorize(:green)} dexterity points!"
          unless new_stats[:special_abilities].nil?
            unless self.special_abilities.include?(new_stats[:special_abilities])
              self.special_abilities.push(new_stats[:special_abilities])
              puts "You learned a new ability: #{Formatting::upstyle(new_stats[:special_abilities]).colorize(:green)}!"
            end
          end
          STDIN.getc
        end
      end
    end

    def at_full_hp?
      self.hp_cur == self.hp_max
    end

    private

    def player_death
      puts 'Your actions have reduced you to death.'.colorize(:red)
      return 'death'
    end

    def print_traveling_text(direction_text)
      Audio.play_synth(:player_travel)
      Animation.run(phrase: "* #{direction_text} *", oneline: false)
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
