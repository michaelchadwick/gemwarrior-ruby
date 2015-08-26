# lib/gemwarrior/battle.rb
# Monster battle

require_relative 'game_options'

module Gemwarrior
  class Battle
    # CONSTANTS
    ERROR_ATTACK_OPTION_INVALID = 'That will not do anything against the monster.'
    BEAST_MODE_ATTACK           = 100
    ESCAPE_TEXT                 = '** POOF **'

    attr_accessor :world, :player, :monster, :player_is_defending

    def initialize(options)
      self.world                = options.fetch(:world)
      self.player               = options.fetch(:player)
      self.monster              = options.fetch(:monster)
      self.player_is_defending  = false
    end

    def start(is_arena = nil, is_event = nil)
      Audio.play_synth(:battle_start)

      # begin battle!
      print_battle_header unless is_arena

      if is_arena
        print '  Your opponent is now...'
        Animation.run(phrase: "#{monster.name.upcase}", speed: :slow, oneline: true)
        print "!\n"
      elsif is_event
        puts "  You are ambushed by #{monster.name}!".colorize(:yellow)
      else
        puts "  You decide to attack #{monster.name}!"
      end

      puts "  #{monster.name} cries out: \"#{monster.battlecry}\""

      # first strike!
      unless is_arena
        if monster_strikes_first?(is_event)
          puts "  #{monster.name} strikes first!".colorize(:yellow)
          monster_attacks_player
        end
      end

      # main battle loop
      loop do
        skip_next_monster_attack = false

        if monster_dead?
          result = monster_death
          return result
        elsif player_dead?
          player_death
          return 'death'
        end

        # check for near death
        puts "  You are almost dead!\n".colorize(:yellow)             if player_near_death?
        puts "  #{monster.name} is almost dead!\n".colorize(:yellow)  if monster_near_death?

        puts

        # print health info
        print "  #{player.name.upcase.ljust(12)} :: #{player.hp_cur.to_s.rjust(3)} HP"
        print " (LVL: #{player.level})" if GameOptions.data['debug_mode']
        print "\n"

        print "  #{monster.name.upcase.ljust(12)} :: "
        if GameOptions.data['debug_mode'] || player.special_abilities.include?(:rocking_vision)
          print "#{monster.hp_cur.to_s.rjust(3)}"
        else
          print '???'
        end
        print ' HP'
        print " (LVL: #{monster.level})" if GameOptions.data['debug_mode']
        print "\n"
        puts

        self.player_is_defending = false

        # battle options prompt
        print_battle_options
        player_action = STDIN.gets.chomp.downcase

        # player action
        case player_action
        when 'fight', 'f', 'attack', 'a'
          can_attack = true

          # gun exception
          if player.has_weapon_equipped?
            if player.inventory.weapon.name.eql?('gun')
              if player.inventory.contains_item?('bullet')
                player.inventory.remove_item('bullet')
              else
                puts '  Your gun is out of bullets! Running is your best option now.'.colorize(:red)
                can_attack = false
              end
            end
          end

          if can_attack
            puts "  You attack #{monster.name}#{player.cur_weapon_name}!"
            dmg = calculate_damage_to(monster)
            if dmg > 0
              Audio.play_synth(:battle_player_attack)

              take_damage(monster, dmg)
              if monster_dead?
                result = monster_death
                return result
              end
            else
              Audio.play_synth(:battle_player_miss)

              puts '  You miss entirely!'.colorize(:yellow)
            end
          end
        when 'defend', 'd'
          puts '  You dig in and defend this round.'
          self.player_is_defending = true
        when 'item', 'i'
          if player.inventory.is_empty?
            puts '  You have no items!'
            next
          elsif player.inventory.contains_battle_item?
            puts '  Which item do you want to use?'
            puts
            b_items = player.inventory.list_battle_items
            count = 0
            b_items.each do |bi|
              puts "  (#{count + 1}) #{bi.name}"
              count += 1
            end
            puts '  (x) exit'

            loop do
              print_battle_prompt
              answer = gets.chomp.downcase

              case answer
              when 'x', 'q'
                skip_next_monster_attack = true
                break
              else
                begin
                  item = b_items[answer.to_i - 1]
                  if item
                    result = item.use(world)
                    player.hp_cur += result[:data]
                    player.inventory.remove_item(item.name) if item.consumable
                    break
                  end
                rescue
                  puts '  That is not a valid item choice.'
                  puts
                  next
                end
              end
            end
          else
            puts '  You have no battle items!'
          end
        when 'look', 'l'
          print "  #{monster.name}".colorize(:white)
          print " (#{monster.hp_cur}/#{monster.hp_max} HP): #{monster.description}\n"
          puts "  It has some distinguishing features, too: face is #{monster.face.colorize(:yellow)}, hands are #{monster.hands.colorize(:yellow)}, and mood, currently, is #{monster.mood.colorize(:yellow)}."
          if GameOptions.data['debug_mode']
            puts '  If defeated, will receive:'
            puts "  >> XP   : #{monster.xp}"
            puts "  >> ROX  : #{monster.rox}"
            puts "  >> ITEMS: #{monster.inventory.list_contents}"
            next
          end
        when 'pass', 'p'
          puts '  You decide to pass your turn for some reason. Brave!'
        when 'run', 'r'
          if player_escape?(is_arena)
            monster.hp_cur = monster.hp_max
            puts "  You successfully elude #{monster.name}!".colorize(:green)
            print_escape_text
            print_battle_line
            return
          else
            puts '  You were not able to run away! :-('.colorize(:yellow)
          end
        else
          puts "  #{ERROR_ATTACK_OPTION_INVALID}"
          next
        end

        # monster action
        monster_attacks_player unless skip_next_monster_attack
      end
    end

    private

    # NEUTRAL
    def calculate_damage_to(entity)
      miss = rand(0..(100 + entity.defense))
      if miss < 15
        0
      else
        if entity.eql?(monster)
          # base attack range
          base_atk_lo = player.atk_lo
          base_atk_hi = player.atk_hi

          if player.has_weapon_equipped?
            base_atk_lo += player.inventory.weapon.atk_lo
            base_atk_hi += player.inventory.weapon.atk_hi
          end

          atk_range = base_atk_lo..base_atk_hi

          # beast mode modifier
          if GameOptions.data['beast_mode']
            atk_range = BEAST_MODE_ATTACK..BEAST_MODE_ATTACK
          # level 3 ability modifier
          elsif player.special_abilities.include?(:rock_slide)
            lo_boost = rand(0..9)

            if lo_boost >= 7
              puts "#{player.name} uses Rock Slide for added damage!"
              hi_boost = lo_boost + rand(0..5)
              atk_range = (player.atk_lo + lo_boost)..(player.atk_hi + hi_boost)
            end
          end

          # return attack range
          return rand(atk_range)
        else
          dmg = rand(monster.atk_lo..monster.atk_hi)
          dmg -= (entity.defense / 2) if player_is_defending
          return dmg
        end
      end
    end

    def take_damage(entity, dmg)
      entity.hp_cur = entity.hp_cur.to_i - dmg.to_i
      who_gets_wounded_start = ''

      if entity.eql?(monster)
        who_gets_wounded_start = "  > You wound #{monster.name} for ".colorize(:green)
        who_gets_wounded_end   = " point(s)!\n".colorize(:green)
      else
        who_gets_wounded_start = '  > You are wounded for '.colorize(:red)
        who_gets_wounded_end   = " point(s)!\n".colorize(:red)
      end

      print who_gets_wounded_start
      Animation.run(phrase: dmg.to_s, speed: :slow, oneline: true, alpha: false, random: false)
      print who_gets_wounded_end
    end

    # MONSTER
    def monster_strikes_first?(is_event = nil)
      if (monster.dexterity > player.dexterity) || is_event
        return true
      else
        dex_diff = player.dexterity - monster.dexterity
        rand_dex = rand(0..dex_diff)
        if rand_dex % 2 > 0
          return true
        else
          return false
        end
      end
    end

    def monster_attacks_player
      puts "  #{monster.name} attacks you!".colorize(:yellow)

      dmg = calculate_damage_to(player)
      if dmg > 0
        Audio.play_synth(:battle_monster_attack)

        take_damage(player, dmg)
      else
        Audio.play_synth(:battle_monster_miss)

        puts "  #{monster.name} misses entirely!".colorize(:yellow)
      end
    end

    def monster_near_death?
      ((monster.hp_cur.to_f / monster.hp_max.to_f) < 0.10)
    end

    def monster_dead?
      monster.hp_cur <= 0
    end

    def monster_death
      Audio.play_synth(:battle_win)
      puts "  YOU HAVE DEFEATED #{monster.name.upcase}!\n".colorize(:green)

      if monster.is_boss
        # stats
        world.player.bosses_killed += 1

        if monster.name.eql?('emerald')
          puts '  You just beat THE FINAL BOSS! Unbelievable!'
          puts

          reward_player(monster)

          # game ending: initiate
          return monster.initiate_ending(world)
        elsif monster.name.eql?('jaspern')
          puts '  You just beat a MINIBOSS! Fantastic!'
          puts

          reward_player(monster)

          # river bridge boss: initiate
          return monster.river_bridge_success(world)
        else
          reward_player(monster)

          world.location_by_coords(player.cur_coords).remove_monster(monster.name)
        end
      else
        # stats
        world.player.monsters_killed += 1

        reward_player(monster)

        world.location_by_coords(player.cur_coords).remove_monster(monster.name)
      end
    end

    def reward_player(monster)
      puts '  You get the following spoils of war:'
      puts "   XP   : #{monster.xp}".colorize(:green)
      puts "   ROX  : #{monster.rox}".colorize(:green)
      unless monster.inventory.nil?
        puts "   ITEMS: #{monster.inventory.list_contents}".colorize(:green) unless monster.inventory.items.empty?
      end
      print_battle_line
      world.player.update_stats(reason: :monster, value: monster)
      puts
    end

    # PLAYER
    def player_near_death?
      ((player.hp_cur.to_f / player.hp_max.to_f) < 0.10 && !GameOptions.data['god_mode'])
    end

    def player_dead?
      (player.hp_cur <= 0 && !GameOptions.data['god_mode'])
    end

    def player_death
      puts "  You are dead, slain by the #{monster.name}!".colorize(:red)
      print_battle_line
    end

    def player_escape?(is_arena)
      unless is_arena
        if player.dexterity > monster.dexterity
          return true
        else
          dex_diff = monster.dexterity - player.dexterity
          rand_dex = rand(0..dex_diff)
          rand_dex += rand(0..1) # slight extra chance modifier

          if rand_dex % 2 > 0
            return true
          else
            return false
          end
        end
      end
      false
    end

    # STATUS TEXT
    def print_escape_text
      print '  '
      Animation.run(phrase: ESCAPE_TEXT, oneline: false)
    end

    def print_battle_line
      GameOptions.data['wrap_width'].times { print '*'.colorize(background: :red, color: :white) }
      print "\n"
    end

    def print_battle_options
      puts '  What do you do?'
      print '  '
      print "#{'['.colorize(:yellow)}"
      print "#{'F'.colorize(:green)}#{'ight]['.colorize(:yellow)}"
      print "#{'D'.colorize(:green)}#{'efend]['.colorize(:yellow)}"
      print "#{'L'.colorize(:green)}#{'ook]['.colorize(:yellow)}"
      print "#{'I'.colorize(:green)}#{'tem]['.colorize(:yellow)}"
      print "#{'P'.colorize(:green)}#{'ass]['.colorize(:yellow)}"
      print "#{'R'.colorize(:green)}#{'un]'.colorize(:yellow)}"
      print "\n"
      print_battle_prompt
    end

    def print_battle_prompt
      print '  [BATTLE]> '
    end

    def print_battle_header
      print_battle_line
      puts ' BATTLE BEGINS!'.ljust(GameOptions.data['wrap_width']).colorize(background: :red, color: :white)
      print_battle_line
    end
  end
end
