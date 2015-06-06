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
      puts "#{monster.name} cries out: #{monster.battlecry}"

      # first strike!
      if monster_strikes_first?
        puts "#{monster.name} strikes first!"
        monster_attacks_player
      end
      
      # main battle loop
      loop do
        if (monster.hp_cur <= 0)
          monster_death
          return
        elsif (player.hp_cur <= 0 && !player.god_mode)
          player_death
        end

        puts
        puts "[Fight/Attack][Look][Run]"
        puts "P :: #{player.hp_cur} HP\n"
        puts "M :: #{monster.hp_cur} HP\n"
        
        if ((player.hp_cur.to_f / player.hp_max.to_f) < 0.10)
          puts "You are almost dead!\n"
        end
        if ((monster.hp_cur.to_f / monster.hp_max.to_f) < 0.10)
          puts "#{monster.name} is almost dead!\n"
        end
        
        puts 'What do you do?'
        cmd = gets.chomp.downcase
        
        # player action
        case cmd
        when 'fight', 'f', 'attack', 'a'
          puts "You attack #{monster.name}#{player.cur_weapon_name}!"
          dmg = calculate_damage_to(monster)
          if dmg > 0
            puts "You wound it for #{dmg} point(s)!"
            take_damage(monster, dmg)
            if (monster.hp_cur <= 0)
              monster_death
              return
            end
          else
            puts "You miss entirely!"
          end
        when 'look', 'l'
          puts "#{monster.name}: #{monster.description}"
          puts "Its got some distinguishing features, too: face is #{monster.face}, hands are #{monster.hands}, and general mood is #{monster.mood}."
        when 'run', 'r'
          if player_escape?
            monster.hp_cur = monster.hp_max
            puts "You successfully elude #{monster.name}!"
            return
          else
            puts "You were not able to run away! :-("
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
        puts "You are wounded for #{dmg} point(s)!"
        take_damage(player, dmg)
        if player.hp_cur <= 0
          player_death
        end
      else
        puts "#{monster.name} misses entirely!"
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
    
    def monster_death
      puts "You have defeated #{monster.name}!"
      puts "You have received #{monster.xp} XP!"
      puts "You have found #{monster.rox} barterable rox on your slain opponent!"
      print_battle_line
      update_player_stats
      world.location_by_coords(player.cur_coords).remove_monster(monster.name)
    end
    
    def player_death
      puts "You are dead, slain by the #{monster.name}!"
      puts 'Your adventure ends here. Try again next time!'
      print_battle_line
      exit(0)
    end
    
    def update_player_stats
      player.xp = player.xp + monster.xp
      player.rox = player.rox + monster.rox
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
    
    def print_battle_line
      puts '**************************************'
    end
  end
end
