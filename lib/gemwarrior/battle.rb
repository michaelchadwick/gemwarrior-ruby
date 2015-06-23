# lib/gemwarrior/battle.rb
# Monster battle

require_relative 'misc/player_levels'

module Gemwarrior
  class Battle
    include PlayerLevels
  
    # CONSTANTS
    ## ERRORS
    ERROR_ATTACK_OPTION_INVALID = 'That will not do anything against the monster.'
    BEAST_MODE_ATTACK           = 100
    
    ## MESSAGES
    TEXT_ESCAPE                 = 'POOF'
    
    attr_accessor :world, :player, :monster
    
    def initialize(options)
      self.world    = options.fetch(:world)
      self.player   = options.fetch(:player)
      self.monster  = options.fetch(:monster)
    end
    
    def start
      print_battle_line
      puts "You decide to attack the #{monster.name}!"
      puts "#{monster.name} cries out: \"#{monster.battlecry}\"".colorize(:yellow)

      # first strike!
      if monster_strikes_first?
        puts "#{monster.name} strikes first!".colorize(:yellow)
        monster_attacks_player
      end
      
      # main battle loop
      loop do
        if monster_dead?
          monster_death
          return
        elsif player_dead?
          player_death
        end

        if player_near_death?
          puts "You are almost dead!\n".colorize(:yellow)
        end
        if monster_near_death?
          puts "#{monster.name} is almost dead!\n".colorize(:yellow)
        end
        
        puts
        print "PLAYER  :: #{player.hp_cur.to_s.rjust(3)} HP"
        if world.debug_mode
          print " (LVL: #{player.level})"
        end
        print "\n"
        
        print "MONSTER :: "
        if world.debug_mode || PlayerLevels::get_level_stats(player.level)[:special_abilities].include?(:rocking_vision)
          print "#{monster.hp_cur.to_s.rjust(3)}"
        else
          print "???"
        end
        print " HP"
        if world.debug_mode
          print " (LVL: #{monster.level})"
        end
        print "\n"
        puts
        
        puts 'What do you do?'
        puts "[Fight/Attack][Look][Run]".colorize(:color => :yellow)
        
        cmd = gets.chomp.downcase

        # player action
        case cmd
        when 'fight', 'f', 'attack', 'a'
          puts "You attack #{monster.name}#{player.cur_weapon_name}!"
          dmg = calculate_damage_to(monster)
          if dmg > 0
            take_damage(monster, dmg)
            if monster_dead?
              monster_death
              return
            end
          else
            puts "You miss entirely!".colorize(:yellow)
          end
        when 'look', 'l'
          print "#{monster.name}".colorize(:white)
          print " (#{monster.hp_cur}/#{monster.hp_max} HP): #{monster.description}\n"
          puts "It has some distinguishing features, too: face is #{monster.face}, hands are #{monster.hands}, and general mood is #{monster.mood}."
          if world.debug_mode
            puts "If defeated, will receive:"
            puts " >> XP   : #{monster.xp}"
            puts " >> ROX  : #{monster.rox}"
            puts " >> ITEMS: #{monster.inventory.list_contents}"
            next
          end
        when 'run', 'r'
          if player_escape?
            monster.hp_cur = monster.hp_max
            puts "You successfully elude #{monster.name}!".colorize(:green)
            print_escape_text
            return
          else
            puts "You were not able to run away! :-(".colorize(:yellow)
          end
        else
          puts ERROR_ATTACK_OPTION_INVALID
          next
        end
        
        # monster action
        monster_attacks_player
      end
    end
    
    private
    
    # NEUTRAL   
    def calculate_damage_to(entity)
      miss = rand(0..(100 + entity.defense))
      if (miss < 15)
        0
      else
        if entity.eql?(monster)
          if player.beast_mode
            atk_range = BEAST_MODE_ATTACK..BEAST_MODE_ATTACK
          else
            atk_range = player.atk_lo..player.atk_hi
          end
          rand(atk_range)
        else
          rand(monster.atk_lo..monster.atk_hi)
        end
      end
    end
    
    def take_damage(entity, dmg)
      entity.hp_cur = entity.hp_cur.to_i - dmg.to_i
      who_gets_wounded = ''
      
      if entity.eql?(monster)
        who_gets_wounded = "> You wound #{monster.name} for "
      else
        who_gets_wounded = "> You are wounded for "
      end
      
      print who_gets_wounded
      Animation::run({ :phrase => dmg.to_s, :speed => :slow, :oneline => true, :alpha => false, :random => false })
      print " point(s)!\n"
    end
    
    # MONSTER
    def monster_strikes_first?
      if (monster.dexterity > player.dexterity)
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
      puts "#{monster.name} attacks you!"
      dmg = calculate_damage_to(player)
      if dmg > 0
        take_damage(player, dmg)
        if player_dead?
          player_death
        end
      else
        puts "#{monster.name} misses entirely!".colorize(:yellow)
      end
    end

    def monster_near_death?
      ((monster.hp_cur.to_f / monster.hp_max.to_f) < 0.10)
    end
    
    def monster_dead?
      monster.hp_cur <= 0
    end
    
    def monster_death
      puts "You have defeated #{monster.name}!\n".colorize(:green)
      if monster.is_boss
        if monster.name.eql?("Emerald")
          puts monster.defeated_text
          exit(0)
        else
          puts 'You just beat a boss monster. Way to go!'
          puts " XP : #{monster.xp}".colorize(:green)
          puts " ROX: #{monster.rox}".colorize(:green)
          print_battle_line
          update_player_stats
          world.location_by_coords(player.cur_coords).remove_monster(monster.name)
        end
      else
        puts 'You get the following spoils of war:'
        puts " XP   : #{monster.xp}".colorize(:green)
        puts " ROX  : #{monster.rox}".colorize(:green)
        unless monster.inventory.nil?
          puts " ITEMS: #{monster.inventory.list_contents}".colorize(:green) unless monster.inventory.items.empty?
        end
        print_battle_line
        update_player_stats
        world.location_by_coords(player.cur_coords).remove_monster(monster.name)
      end
    end
    
    # PLAYER
    def update_player_stats
      old_player_level = PlayerLevels::check_level(player.xp)
      
      player.xp = player.xp + monster.xp
      player.rox = player.rox + monster.rox
      
      monster_items = monster.inventory.items
      unless monster_items.nil?
        player.inventory.items.concat monster_items unless monster_items.empty?
      end
      
      new_player_level = PlayerLevels::check_level(player.xp)
      
      if new_player_level > old_player_level
        Animation::run({:phrase => '** LEVEL UP! **'})
        new_stats = PlayerLevels::get_level_stats(new_player_level)
        
        player.level = new_stats[:level]
        puts "You are now level #{player.level}!"
        player.hp_cur = new_stats[:hp_max]
        player.hp_max = new_stats[:hp_max]
        puts "You now have #{player.hp_max} hit points!"
        player.stam_cur = new_stats[:stam_max]
        player.stam_max = new_stats[:stam_max]
        puts "You now have #{player.stam_max} stamina points!"
        player.atk_lo = new_stats[:atk_lo]
        player.atk_hi = new_stats[:atk_hi]
        puts "You now have an attack of #{player.atk_lo}-#{player.atk_hi}!"
        player.defense = new_stats[:defense]
        puts "You now have #{player.defense} defensive points!"
        player.dexterity = new_stats[:dexterity]
        puts "You now have #{player.dexterity} dexterity points!"
      end
    end
    
    def player_near_death?
      ((player.hp_cur.to_f / player.hp_max.to_f) < 0.10 && !player.god_mode)
    end
    
    def player_dead?
      (player.hp_cur <= 0 && !player.god_mode)
    end
    
    def player_death
      puts "You are dead, slain by the #{monster.name}!".colorize(:red)
      puts 'Your adventure ends here. Try again next time!'.colorize(:red)
      print_battle_line
      exit(0)
    end
    
    def player_escape?
      if (player.dexterity > monster.dexterity)
        return true
      else
        dex_diff = monster.dexterity - player.dexterity
        rand_dex = rand(0..dex_diff)
        if rand_dex % 2 > 0
          return true
        else
          return false
        end
      end
    end
    
    # STATUS TEXT
    
    def print_escape_text
      Animation::run({ :phrase => "** POOF **", :oneline => true })
    end
    
    def print_battle_line
      puts '******************************'
    end
  end
end
