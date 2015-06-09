# lib/gemwarrior/battle.rb
# Monster battle

module Gemwarrior
  class Battle
    # CONSTANTS
    ## ERRORS
    ERROR_ATTACK_OPTION_INVALID = 'That will not do anything against the monster.'
    
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

        puts
        puts "[Fight/Attack][Look][Run]".colorize(:color => :white, :background => :green)
        puts "P :: #{player.hp_cur.to_s.rjust(3)} HP\n"
        puts "M :: #{monster.hp_cur.to_s.rjust(3)} HP\n"
        
        if player_near_death?
          puts "You are almost dead!\n".colorize(:yellow)
        end
        if monster_near_death?
          puts "#{monster.name} is almost dead!\n".colorize(:yellow)
        end
        
        puts 'What do you do?'
        cmd = gets.chomp.downcase
        
        # player action
        case cmd
        when 'fight', 'f', 'attack', 'a'
          puts "You attack #{monster.name}#{player.cur_weapon_name}!"
          dmg = calculate_damage_to(monster)
          if dmg > 0
            puts "> You wound it for #{dmg} point(s)!".colorize(:yellow)
            take_damage(monster, dmg)
            if monster_dead?
              monster_death
              return
            end
          else
            puts "You miss entirely!".colorize(:yellow)
          end
        when 'look', 'l'
          puts "#{monster.name}: #{monster.description}"
          puts "Its got some distinguishing features, too: face is #{monster.face}, hands are #{monster.hands}, and general mood is #{monster.mood}."
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
    
    def calculate_damage_to(entity)
      miss = rand(0..100)
      if (miss < 15)
        0
      else
        if entity.eql?(monster)
          rand(player.atk_lo..player.atk_hi)
        else
          rand(monster.atk_lo..monster.atk_hi)
        end
      end
    end
    
    def take_damage(entity, dmg)
      entity.hp_cur = entity.hp_cur.to_i - dmg.to_i
    end
    
    def monster_attacks_player
      puts "#{monster.name} attacks you!"
      dmg = calculate_damage_to(player)
      if dmg > 0
        puts "> You are wounded for #{dmg} point(s)!".colorize(:yellow)
        take_damage(player, dmg)
        if player_dead?
          player_death
        end
      else
        puts "#{monster.name} misses entirely!".colorize(:yellow)
      end
    end
    
    def calculate_monster_damage
      miss = rand(0..100)
      if (miss < 15)
        0
      else
        rand(player.atk_lo..player.atk_hi)
      end
    end
    
    def monster_near_death?
      ((monster.hp_cur.to_f / monster.hp_max.to_f) < 0.10)
    end
    
    def monster_dead?
      monster.hp_cur <= 0
    end
    
    def monster_death
      puts "You have defeated #{monster.name}!".colorize(:green)
      puts 'You get the following spoils of war:'
      puts " XP : #{monster.xp}".colorize(:green)
      puts " ROX: #{monster.rox}".colorize(:green)
      print_battle_line
      update_player_stats
      world.location_by_coords(player.cur_coords).remove_monster(monster.name)
    end
    
    def update_player_stats
      player.xp = player.xp + monster.xp
      player.rox = player.rox + monster.rox
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
      escape = Thread.new do
        print "* "
        print "#{Matrext::process({ :phrase => 'POOF', :sl => true })}"
        print " *\n"
      end
      return escape.join
    end
    
    def print_battle_line
      puts '**************************************'
    end
  end
end
