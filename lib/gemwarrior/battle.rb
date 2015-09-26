# lib/gemwarrior/battle.rb
# Monster battle

require_relative 'game_options'

module Gemwarrior
  class Battle
    # CONSTANTS
    ERROR_ATTACK_OPTION_INVALID = 'That will not do anything against the monster.'
    BEAST_MODE_ATTACK_LO        = 100
    BEAST_MODE_ATTACK_HI        = 200
    ATTEMPT_SUCCESS_LO_DEFAULT  = 0
    ATTEMPT_SUCCESS_HI_DEFAULT  = 100
    MISS_CAP_DEFAULT            = 20
    LV4_ROCK_SLIDE_MOD_LO           = 6
    LV5_MOD_LO                  = 7
    LV5_MOD_HI                  = 14
    ESCAPE_TEXT                 = '** POOF **'

    attr_accessor :world,
                  :player,
                  :monster,
                  :player_is_defending

    def initialize(options)
      self.world                = options.fetch(:world)
      self.player               = options.fetch(:player)
      self.monster              = options.fetch(:monster)
      self.player_is_defending  = false
    end

    def start(is_arena = false, is_event = false)
      # begin battle!
      Audio.play_synth(:battle_start)
      print_battle_header unless is_arena

      # print opponent announcement, depending on reason for battle
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

      # first strike! (unless arena or emerald)
      # shifty woman time, if emerald
      if monster.name.eql?('emerald')
        if world.shifty_to_jewel && !world.shifty_has_jeweled
          puts
          puts '  Suddenly, the Shifty Woman appears out of nowhere, and stands between you and Emerald!'
          STDIN.getc
          print '  '
          Person.new.speak('Hey, friend. Now it is time to finally get my revenge on ol\' Emer!')
          STDIN.getc
          puts '  She brandishes a now-sharpened-to-a-fine-point-and-glowing version of the Sand Jewel you gave to her and plunges it deep into Emerald\'s side, causing him to scream in agony.'
          puts
          print '  '
          Person.new.speak('THAT was for murdering my parents!')
          STDIN.getc
          puts '  She uses the hand not gripping the shiny blade to conjure up a small bolt of lightning, which she then flings directly at Emerald\'s chest.'
          puts
          print '  '
          Person.new.speak('And THAT was for stealing the ShinyThing(tm)!')
          STDIN.getc
          puts '  Emerald growls mightily, looking quite put off at the turn of events.'
          STDIN.getc
          puts '  He is not without strength, however, and pulls the weapon from his body with one hand while conjuring a fireball with his other, sending it right back at the Shifty Woman. Her glee at delivering a seemingly crushing blow is thwarted as she crumples to the floor.'
          STDIN.getc
          puts '  Both combatants are breathing heavily and groaning through their injuries. The Shifty Woman looks pretty hurt, and begins eyeing an exit from this mess.'
          STDIN.getc
          print '  '
          Person.new.speak('I may not have been able to finish you off, but my friend here will succeed where I and the land of Jool have failed. Goodbye and good luck!')
           puts '  The Shifty Woman regains her compsure just enough to limp off to a back door, disappearing.'
          STDIN.getc

          if GameOptions.data['debug_mode']
            puts
            puts '  Emerald Stats Before Altercation'
            puts "  HP   : #{monster.hp_cur}"
            puts "  DEF  : #{monster.defense}"
            puts "  A_LO : #{monster.atk_lo}"
            puts "  A_HI : #{monster.atk_hi}"
          end

          monster.hp_cur -= (monster.hp_cur * 0.3).floor
          monster.defense -= (monster.defense * 0.25).floor
          monster.atk_lo -= (monster.atk_lo * 0.2).floor
          monster.atk_hi -= (monster.atk_hi * 0.2).floor

          if GameOptions.data['debug_mode']
            puts
            puts '  Emerald Stats After Altercation'
            puts "  HP   : #{monster.hp_cur}"
            puts "  DEF  : #{monster.defense}"
            puts "  A_LO : #{monster.atk_lo}"
            puts "  A_HI : #{monster.atk_hi}"
            puts
          end

          puts '  Emerald has been wounded, but he is not done with this world yet. You approach him, wits about you, ready for battle.'
          world.shifty_has_jeweled = true
        end
      elsif monster_strikes_first?(is_arena, is_event)
        puts "  #{monster.name} strikes first!".colorize(:yellow)
        monster_attacks_player
      end
      
      # LV6:STONE_FACE modifier (chance to auto-win)
      # Doesn't work against bosses, nor if battle is an event or in the arena
      if player.special_abilities.include?(:stone_face) && !monster.is_boss && !is_event && !is_arena
        level_diff = (player.level - monster.level) * 4
        chance_range = 0..(30 + level_diff)
        roll = rand(0..100)

        if GameOptions.data['debug_mode']
          puts
          puts "  (MOD) LV6: Stone Face"
          puts "  SUCCESS_RANGE: #{chance_range}"
          puts "  SUCCESS_ROLL : #{roll}"
        end

        if chance_range.include?(roll)
          puts "  You use your STONE FACE to tell the #{monster.name} you mean business, and #{monster.name} just gives up!".colorize(:green)
          return monster_death
        end
      end

      # main battle loop
      loop do
        skip_next_monster_attack = false

        # 1. check for death to end battle
        if monster_dead?
          result = monster_death
          return result
        elsif player_dead?
          player_death
          return 'death'
        end

        # 2. print general info and display options prompt
        print_near_death_info
        print_combatants_health_info
        print_battle_options_prompt

        # 3. get player action
        self.player_is_defending = false
        player_action = STDIN.gets.chomp.downcase

        # 4. parse player action
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
            dmg = calculate_damage(player, monster)
            if dmg > 0
              Audio.play_synth(:battle_player_attack)

              take_damage(monster, dmg)
              if monster_dead?
                result = monster_death
                return result
              end
            else
              Audio.play_synth(:battle_player_miss)

              puts '  You do no damage!'.colorize(:yellow)
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
            puts "  >> ITEMS: #{monster.inventory.contents}"
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

        # 5. parse monster action
        monster_attacks_player unless skip_next_monster_attack
      end
    end

    private

    # NEUTRAL
    def calculate_damage(attacker, defender)
      # things that modify attack success and damage
      a_dex = attacker.dexterity
      d_dex = defender.dexterity
      d_def = defender.defense

      # player attacking monster
      if defender.eql?(monster)
        # attack success defined by attacker's and defender's dexterity
        attempt_success_lo = ATTEMPT_SUCCESS_LO_DEFAULT
        attempt_success_hi = ATTEMPT_SUCCESS_HI_DEFAULT

        # success range to hit based on dexterity
        attempt_success_hi += rand((a_dex)..(a_dex+2))
        attempt_success_hi -= rand((d_dex)..(d_dex+2))

        # weapon can change dexterity
        if attacker.has_weapon_equipped?
          attempt_success_hi += attacker.inventory.weapon.dex_mod
        end

        # compute attempt success
        attempt = rand(attempt_success_lo..attempt_success_hi)
        miss_cap = MISS_CAP_DEFAULT

        ######################
        # ACCURACY MODIFIERS #
        # vvvvvvvvvvvvvvvvvv #
        ######################

        ### LV5:GRANITON modifier (more accuracy)
        if player.special_abilities.include?(:graniton)
          miss_cap -= rand(LV5_MOD_LO..LV5_MOD_HI)
        end

        ######################
        # ^^^^^^^^^^^^^^^^^^ #
        # ACCURACY MODIFIERS #
        ######################

        # number to beat for attack success
        success_min = rand(miss_cap..miss_cap + 5)

        if GameOptions.data['debug_mode']
          puts
          puts '  Player Roll for Attack:'.colorize(:green)
          puts "  ATTEMPT_RANGE: #{attempt_success_lo}..#{attempt_success_hi}"
          puts "  MUST_BEAT    : #{success_min}"
          if attempt > success_min
            puts "  ATTEMPT_ROLL : #{attempt.to_s.colorize(:green)}"
          else
            puts "  ATTEMPT_ROLL : #{attempt.to_s.colorize(:red)}"
          end
        end

        # no miss, so attack
        if attempt > success_min
          # base player damage range
          base_atk_lo = player.atk_lo
          base_atk_hi = player.atk_hi

          # weapon increases damage range
          if player.has_weapon_equipped?
            base_atk_lo += player.inventory.weapon.atk_lo
            base_atk_hi += player.inventory.weapon.atk_hi
          end

          # non-modified damage range
          dmg_range = base_atk_lo..base_atk_hi

          ####################
          # DAMAGE MODIFIERS #
          # vvvvvvvvvvvvvvvv #
          ####################

          ### DEBUG:BEAST_MODE modifier (ludicrously higher damage range)
          if GameOptions.data['beast_mode']
            dmg_range = BEAST_MODE_ATTACK_LO..BEAST_MODE_ATTACK_HI
          ### LV4:ROCK_SLIDE modifier (increased damage range)
          elsif player.special_abilities.include?(:rock_slide)
            lo_boost = rand(0..9)
            hi_boost = lo_boost + rand(5..10)

            if GameOptions.data['debug_mode']
              puts
              puts '  (MOD) LV4: Rock Slide'
              puts "  Rock Slide lo_boost: #{lo_boost}"
              puts "  Rock Slide hi_boost: #{hi_boost}"
            end

            if lo_boost >= LV4_ROCK_SLIDE_MOD_LO
              puts "  You use Rock Slide for added damage!"
              dmg_range = (player.atk_lo + lo_boost)..(player.atk_hi + hi_boost)
            else
              puts "  Rock Slide failed :(" if GameOptions.data['debug_mode']
            end
          end

          ####################
          # ^^^^^^^^^^^^^^^^ #
          # DAMAGE MODIFIERS #
          ####################

          # get base damage to apply
          base_dmg = rand(dmg_range)

          # lower value due to defender's defense
          dmg = base_dmg - d_def

          # 50% chance of doing 1 point of damage even if you were going to do no damage
          hail_mary = [dmg, 1].sample
          dmg = hail_mary if dmg <= 0

          if GameOptions.data['debug_mode']
            puts
            puts '  Player Roll for Damage:'.colorize(:green)
            puts "  DMG_RANGE  : #{dmg_range}"
            puts "  DMG_ROLL   : #{base_dmg}"
            puts "  MONSTER_DEF: #{d_def}"
            puts "  HAIL_MARY  : #{hail_mary}"
            if dmg > 0
              puts "  NET_DMG    : #{dmg.to_s.colorize(:green)}"
            else
              puts "  NET_DMG    : #{dmg.to_s.colorize(:red)}"
            end
          end

          return dmg
        # missed? no damage
        else
          return 0
        end
      # monster attacking player
      else
        # attack success defined by attacker's and defender's dexterity
        attempt_success_lo = ATTEMPT_SUCCESS_LO_DEFAULT
        attempt_success_hi = ATTEMPT_SUCCESS_HI_DEFAULT

        # success range to hit based on dexterity
        attempt_success_hi += rand((a_dex)..(a_dex+2))
        attempt_success_hi -= rand((d_dex)..(d_dex+2))

        # compute attempt success
        attempt = rand(attempt_success_lo..attempt_success_hi)
        miss_cap = MISS_CAP_DEFAULT

        # number to beat for attack success
        success_min = rand(miss_cap..miss_cap + 5)

        if GameOptions.data['debug_mode']
          puts
          puts '  Monster Roll for Attack:'.colorize(:red)
          puts "  ATTEMPT_RANGE: #{attempt_success_lo}..#{attempt_success_hi}"
          puts "  MUST_BEAT    : #{success_min}"
          if attempt > success_min
            puts "  ATTEMPT_ROLL : #{attempt.to_s.colorize(:green)}"
          else
            puts "  ATTEMPT_ROLL : #{attempt.to_s.colorize(:red)}"
          end
        end

        # no miss, so attack
        if attempt > success_min
          dmg_range = attacker.atk_lo..attacker.atk_lo

          # get base damage to apply
          base_dmg = rand(dmg_range)

          # lower value for defender's defense (and further if actively defending)
          if player_is_defending
            dmg = base_dmg - [(d_def * 1.5).floor, (d_def * 1.5).ceil].sample
          else
            dmg = base_dmg - d_def
          end

          # 25% chance of doing 1 point of damage even if monster was going to do no damage
          hail_mary = [dmg, dmg, dmg, 1].sample
          dmg = hail_mary if dmg <= 0

          if GameOptions.data['debug_mode']
            puts
            puts '  Monster Roll for Damage:'.colorize(:red)
            puts "  DMG_RANGE  : #{dmg_range}"
            puts "  DMG_ROLL   : #{base_dmg}"
            puts "  PLAYER_DEF : #{d_def}"
            puts "  HAIL_MARY  : #{hail_mary}"
            if dmg > 0
              puts "  NET_DMG    : #{dmg.to_s.colorize(:green)}"
            else
              puts "  NET_DMG    : #{dmg.to_s.colorize(:red)}"
            end
          end

          return dmg
        # missed? no damage
        else
          return 0
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
    def monster_strikes_first?(arena_battle = false, event_battle = false)
      if event_battle || arena_battle
        return false
      elsif player.special_abilities.include?(:stone_face)
        return false
      elsif (monster.dexterity > player.dexterity)
        if GameOptions.data['debug_mode']
          puts
          puts "  MONSTER_DEX: #{monster.dexterity}, PLAYER_DEX: #{player.dexterity}"
        end

        return true
      else
        dex_diff = player.dexterity - monster.dexterity
        rand_dex = rand(0..dex_diff)

        if GameOptions.data['debug_mode']
          puts
          puts "  DEX_DIFF    : #{dex_diff}"
          puts "  RAND_DEX    : #{rand_dex}"
          puts "  RAND_DEX % 2: #{rand_dex % 2}"
        end

        if rand_dex % 2 > 0
          return true
        else
          return false
        end
      end
    end

    def monster_attacks_player
      puts "  #{monster.name} attacks you!".colorize(:yellow)

      dmg = calculate_damage(monster, player)
      if dmg > 0
        Audio.play_synth(:battle_monster_attack)

        take_damage(player, dmg)
      else
        Audio.play_synth(:battle_monster_miss)

        puts "  #{monster.name} does no damage!".colorize(:yellow)
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
        puts "   ITEMS: #{monster.inventory.contents}".colorize(:green) unless monster.inventory.items.empty?
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
    def print_near_death_info
      puts "  You are almost dead!\n".colorize(:yellow)             if player_near_death?
      puts "  #{monster.name} is almost dead!\n".colorize(:yellow)  if monster_near_death?
      puts
    end

    def print_combatants_health_info
      print "  #{player.name.upcase.ljust(12).colorize(:green)} :: #{player.hp_cur.to_s.rjust(3)} HP"
      print " (LVL: #{player.level})" if GameOptions.data['debug_mode']
      print "\n"

      print "  #{monster.name.upcase.ljust(12).colorize(:red)} :: "
      if GameOptions.data['debug_mode'] || player.special_abilities.include?(:rocking_vision)
        print "#{monster.hp_cur.to_s.rjust(3)}"
      else
        print '???'
      end
      print ' HP'
      print " (LVL: #{monster.level})" if GameOptions.data['debug_mode']
      print "\n"
      puts
    end

    def print_escape_text
      print '  '
      Animation.run(phrase: ESCAPE_TEXT, oneline: false)
    end

    def print_battle_line
      GameOptions.data['wrap_width'].times { print '*'.colorize(background: :red, color: :white) }
      print "\n"
    end

    def print_battle_options_prompt
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
