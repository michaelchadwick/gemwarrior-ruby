# lib/gemwarrior/world.rb
# World where the locations, monsters, items, etc. exist

require_relative 'game_options'
require_relative 'game_assets'
require_relative 'inventory'
require_relative 'entities/item'
require_relative 'entities/location'
require_relative 'entities/player'

module Gemwarrior
  class World
    # CONSTANTS
    ERROR_LIST_PARAM_INVALID      = 'That is not something that can be listed.'
    ERROR_DESCRIBE_ENTITY_INVALID = 'You do not see that here.'
    WORLD_DIM_WIDTH               = 10
    WORLD_DIM_HEIGHT              = 10

    attr_accessor :monsters,
                  :locations,
                  :weapons,
                  :player,
                  :duration,
                  :emerald_beaten,
                  :shifty_to_jewel,
                  :shifty_has_jeweled

    def describe(point)
      desc_text = "[>>> #{point.name_display.upcase} <<<]".colorize(:cyan)

      if GameOptions.data['debug_mode']
        desc_text << " DL[#{point.danger_level.to_s}] MLR[#{point.monster_level_range.to_s}]".colorize(:yellow)
      end

      desc_text << "\n"

      point_desc = point.description.clone
      
      # specific location description changes
      if point.name.eql?('home')
        if point.contains_item?('tent')
          point_desc << ' Next to the bed, on the floor, is a folded-up tent.'
        end
        if point.contains_item?('letter')
          point_desc << ' Atop the chest you notice a curious letter, folded in three.'
        end
      end

      desc_text << point_desc

      point.populate_monsters(GameMonsters.data) unless point.checked_for_monsters?

      desc_text << "\n >> Monster(s):  #{point.list_monsters.join(', ')}".colorize(:yellow) unless point.list_monsters.empty?
      desc_text << "\n >> Boss(es):    #{point.list_bosses.join(', ')}".colorize(:red) unless point.list_bosses.empty?
      desc_text << "\n >> Thing(s):    #{point.list_items.join(', ')}".colorize(:white) unless point.list_items.empty?
      desc_text << "\n >> Path(s):     #{point.list_paths.join(', ')}".colorize(:white)

      if GameOptions.data['debug_mode']
        desc_text << "\n >>> Actionable: ".colorize(color: :yellow, background: :grey)
        desc_text << point.list_actionable_words.colorize(color: :white, background: :grey)
      end

      desc_text
    end

    def describe_entity(point, entity_name)
      entity_name.downcase!

      if point.contains_item?(entity_name)
        point.items.each do |i|
          if i.name.downcase.eql?(entity_name)
            if GameOptions.data['debug_mode']
              return i.describe_detailed
            else
              return i.describe
            end
          end
        end
      elsif point.has_monster?(entity_name)
        point.monsters_abounding.each do |m|
          if m.name.downcase.eql?(entity_name)
            if GameOptions.data['debug_mode']
              return m.describe_detailed
            else
              return m.describe
            end
          end
        end
      elsif point.has_boss?(entity_name)
        point.bosses_abounding.each do |b|
          if b.name.downcase.eql?(entity_name)
            if GameOptions.data['debug_mode']
              return b.describe_detailed
            else
              return b.describe
            end
          end
        end
      elsif player.inventory.contains_item?(entity_name)
        player.inventory.describe_item(entity_name)
      else
        ERROR_DESCRIBE_ENTITY_INVALID
      end
    end

    def location_by_coords(coords)
      locations.each do |l|
        return l if l.coords.eql?(coords)
      end
      nil
    end

    def location_coords_by_name(name)
      locations.each do |l|
        if l.name.downcase.eql?(name.downcase) or l.name_display.downcase.eql?(name.downcase)
          return l.coords
        end
      end
      nil
    end

    def location_by_name(location_name)
      loc = locations[locations.map(&:name).index(location_name)]
      if loc.nil?
        loc = locations[locations.map(&:name_display).index(location_name)]
      end
      loc.nil? ? nil : loc
    end

    def can_move?(direction)
      location_by_coords(player.cur_coords).has_loc_to_the?(direction)
    end

    def has_monster_to_attack?(monster_name)
      possible_combatants = location_by_coords(player.cur_coords).monsters_abounding.map(&:name) | location_by_coords(player.cur_coords).bosses_abounding.map(&:name)

      possible_combatants.each do |combatant|
        return true if combatant.downcase.eql?(monster_name.downcase)
      end
      false
    end

    def list(param, details = false)
      case param
      when 'players'
        puts '[PLAYERS]'.colorize(:yellow)
        if details
          player.check_self(false)
        else
          ">> players: #{player.name}"
        end
      when 'creatures'
        puts "[CREATURES](#{GameCreatures.data.length})".colorize(:yellow)
        if details
          GameCreatures.data.map { |c| print c.describe_detailed }
          return
        else
          ">> creatures: #{GameCreatures.data.map(&:name).join(', ')}"
        end
      when 'items'
        puts "[ITEMS](#{GameItems.data.length})".colorize(:yellow)
        if details
          GameItems.data.map { |i| print i.describe_detailed }
          return
        else
          ">> items: #{GameItems.data.map(&:name).join(', ')}"
        end
      when 'locations'
        puts "[LOCATIONS](#{locations.length})".colorize(:yellow)
        if details
          locations.map { |l| print l.describe_detailed }
          return
        else
          ">> locations: #{locations.map(&:name).join(', ')}"
        end
      when 'monsters'
        puts "[MONSTERS](#{GameMonsters.data.length})".colorize(:yellow)
        if details
          GameMonsters.data.map { |m| print m.describe_detailed }
          return
        else
          ">> monsters: #{GameMonsters.data.map(&:name).join(', ')}"
        end
      when 'people'
        puts "[PEOPLE](#{GamePeople.data.length})".colorize(:yellow)
        if details
          GamePeople.data.map { |p| print p.describe_detailed }
          return
        else
          ">> people: #{GamePeople.data.map(&:name).join(', ')}"
        end
      when 'weapons'
        puts "[WEAPONS](#{GameWeapons.data.length})".colorize(:yellow)
        if details
          GameWeapons.data.map { |w| print w.describe_detailed }
          return
        else
          ">> weapons: #{GameWeapons.data.map(&:name).join(', ')}"
        end
      else
        ERROR_LIST_PARAM_INVALID
      end
    end

    def print_vars(show_details = false)
      puts "======================\n"
      puts "All Variables in World\n"
      puts "======================\n"
      puts "#{list('players', show_details)}\n\n"
      puts "#{list('creatures', show_details)}\n\n"
      puts "#{list('monsters', show_details)}\n\n"
      puts "#{list('items', show_details)}\n\n"
      puts "#{list('weapons', show_details)}\n\n"
      puts "#{list('locations', show_details)}\n"
      puts
    end

    def print_map(floor)
      0.upto(WORLD_DIM_HEIGHT - 1) do |count_y|
        print '  '
        0.upto(WORLD_DIM_WIDTH - 1) do
          print '---'
        end
        print "\n"
        if GameOptions.data['debug_mode']
          print "#{(WORLD_DIM_HEIGHT - 1) - count_y} "
        else
          print ' '
        end
        0.upto(WORLD_DIM_WIDTH - 1) do |count_x|
          cur_map_coords = {
            x: count_x,
            y: (WORLD_DIM_HEIGHT - 1) - count_y,
            z: floor.nil? ? self.player.cur_coords[:z] : floor.to_i
          }
          if self.player.cur_coords.eql?(cur_map_coords)
            print "|#{'O'.colorize(:cyan)}|"
          elsif location_by_coords(cur_map_coords)
            if GameOptions.data['debug_mode'] || location_by_coords(cur_map_coords).visited
              print '|X|'
            else
              print '| |'
            end
          else
            print '| |'
          end
        end
        print "\n"
      end
      print '  '
      0.upto(WORLD_DIM_WIDTH - 1) do
        print '---'
      end
      puts
      print '   '
      0.upto(WORLD_DIM_WIDTH - 1) do |count_x|
        if GameOptions.data['debug_mode']
          print "#{count_x}  "
        else
          print ' '
        end
      end
      if GameOptions.data['debug_mode']
        puts
        puts
        puts "Current level: #{player.cur_coords[:z]}"
        puts '| | = invalid location'
        puts '|X| = valid location'
        puts '|O| = player'
      end
    end
  end
end
