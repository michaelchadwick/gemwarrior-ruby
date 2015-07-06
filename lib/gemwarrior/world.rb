# lib/gemwarrior/world.rb
# World where the locations, monsters, items, etc. exist

require 'yaml'

require_relative 'entities/item'
require_relative 'entities/location'

module Gemwarrior
  class World
    # CONSTANTS
    LOCATION_DATA_FILE  = 'data/locations.yml'
    WORLD_DIM_WIDTH     = 10
    WORLD_DIM_HEIGHT    = 10

    ## ERRORS
    ERROR_LIST_PARAM_INVALID = 'That is not something that can be listed.'
    ERROR_LOCATION_DESCRIBE_ENTITY_INVALID  = 'You do not see that here.'

    attr_accessor :monsters, :locations, :player, :debug_mode, :use_wordnik, :sound

    def initialize
      self.monsters   = init_monsters
      self.locations  = init_locations
      self.player     = nil
    end

    def print_vars
      puts "======================\n"
      puts "All Variables in World\n"
      puts "======================\n"
      puts "#{list('players', true)}\n"
      puts "#{list('monsters', true)}\n\n"
      puts "#{list('items', true)}\n\n"
      puts "#{list('locations', true)}\n"
    end

    def print_map
      0.upto(WORLD_DIM_HEIGHT - 1) do |count_y|
        print '  '
        0.upto(WORLD_DIM_WIDTH - 1) do
          print '---'
        end
        print "\n"
        print "#{(WORLD_DIM_HEIGHT - 1) - count_y} "
        0.upto(WORLD_DIM_WIDTH - 1) do |count_x|
          cur_map_coords = { x: count_x, y: (WORLD_DIM_HEIGHT - 1) - count_y, z: player.cur_coords[:z] }
          if player.cur_coords.eql?(cur_map_coords)
            print '|O|'
          elsif location_by_coords(cur_map_coords)
            print '|X|'
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
        print "#{count_x}  "
      end
      if debug_mode
        puts
        puts
        puts "Current level: #{player.cur_coords[:z]}"
        puts '| | = invalid location'
        puts '|X| = valid location'
        puts '|O| = player'
      end
      nil
    end

    def list(param, details = false)
      case param
      when 'players'
        puts '[PLAYERS]'
        player.check_self(false)
      when 'monsters'
        puts "[MONSTERS](#{monsters.length})".colorize(:yellow)
        if details
          monsters.map { |m| print m.describe }
          return
        else
          monster_text =  ">> monsters: #{monsters.map(&:name).join(', ')}"
        end
      when 'items'
        item_count = 0
        locations.each do |l|
          l.items.each do |_i|
            item_count += 1
          end
        end
        puts "[ITEMS](#{item_count})".colorize(:yellow)
        if details
          locations.each do |l|
            l.items.map { |i| print i.describe }
          end
          return
        else
          item_list = []
          locations.each do |l|
            l.items.map { |i| item_list << i.name }
          end
          ">> #{item_list.sort.join(', ')}"
        end
      when 'locations'
        puts "[LOCATIONS](#{locations.length})".colorize(:yellow)
        if details
          locations.map { |l| print l.status(debug_mode) }
          return
        else
          ">> #{locations.map(&:name).join(', ')}"
        end
      else
        ERROR_LIST_PARAM_INVALID
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
        return l.coords if l.name.downcase.eql?(name.downcase)
      end
      nil
    end

    def describe(point)
      desc_text = ''
      desc_text << "[ #{point.name} ]".colorize(:green)

      if debug_mode
        desc_text << " DL[#{point.danger_level}] MLR[#{point.monster_level_range}]".colorize(:yellow)
      end

      desc_text << "\n"
      desc_text << point.description

      point.populate_monsters(monsters) unless point.checked_for_monsters?

      desc_text << "\n >> Curious object(s): #{point.list_items.join(', ')}" unless point.list_items.empty?
      desc_text << "\n >> Monster(s) abound: #{point.list_monsters.join(', ')}" unless point.list_monsters.empty?
      desc_text << "\n >> Boss(es) abound: #{point.list_bosses.join(', ')}" unless point.list_bosses.empty?
      desc_text << "\n >> Paths: #{point.list_paths.join(', ')}"

      if debug_mode
        desc_text << "\n >>> Actionable words: "
        desc_text << point.list_actionable_words.colorize(:white)
      end

      desc_text
    end

    def describe_entity(point, entity_name)
      if point.has_item?(entity_name)
        point.items.each do |i|
          if i.name.downcase.eql?(entity_name.downcase)
            if debug_mode
              return i.describe
            else
              return i.description
            end
          end
        end
      elsif
        if point.has_monster?(entity_name)
          point.monsters_abounding.each do |m|
            if m.name.downcase.eql?(entity_name.downcase)
              if debug_mode
                return m.describe
              else
                return m.description
              end
            end
          end
        end
      elsif
        if point.has_boss?(entity_name)
          point.bosses_abounding.each do |b|
            if b.name.downcase.eql?(entity_name.downcase)
              if debug_mode
                return b.describe
              else
                return b.description
              end
            end
          end
        end
      else
        ERROR_LOCATION_DESCRIBE_ENTITY_INVALID
      end
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

    private

    def create_item_objects(item_names)
      items = []
      unless item_names.nil?
        item_names.each do |name|
          items.push(eval(name).new)
        end
      end
      items
    end

    def create_boss_objects(bosses_names)
      bosses = []
      unless bosses_names.nil?
        bosses_names.each do |name|
          bosses.push(eval(name).new)
        end
      end
      bosses
    end

    def init_monsters
      Dir.glob('lib/gemwarrior/entities/monsters/*.rb').each do |item|
        require_relative item[item.index('/', item.index('/') + 1) + 1..item.length]
      end
      Dir.glob('lib/gemwarrior/entities/monsters/bosses/*.rb').each do |item|
        require_relative item[item.index('/', item.index('/') + 1) + 1..item.length]
      end

      self.monsters = [
        Alexandrat.new,
        Amberoo.new,
        Amethystle.new,
        Apatiger.new,
        Aquamarine.new,
        Bloodstorm.new,
        Citrinaga.new,
        Coraliz.new,
        Cubicat.new,
        Diaman.new,
        Emerald.new,
        Garynetty.new
      ]
    end

    def init_locations
      Dir.glob('lib/gemwarrior/entities/items/*.rb').each do |item|
        require_relative item[item.index('/', item.index('/') + 1) + 1..item.length]
      end

      locations = []

      location_data = YAML.load_file(LOCATION_DATA_FILE)

      location_data.each do|l|
        locations.push(Location.new(name: l['name'],
                                    description: l['description'],
                                    danger_level: l['danger_level'],
                                    monster_level_range: l['monster_level_range'].nil? ? nil : l['monster_level_range']['lo']..l['monster_level_range']['hi'],
                                    coords: {
                                      x: l['coords']['x'],
                                      y: l['coords']['y'],
                                      z: l['coords']['z']
                                    },
                                    locs_connected: {
                                      north: l['locs_connected']['north'],
                                      east: l['locs_connected']['east'],
                                      south: l['locs_connected']['south'],
                                      west: l['locs_connected']['west']
                                    },
                                    items: create_item_objects(l['items']),
                                    bosses_abounding: create_boss_objects(l['bosses_abounding'])))
      end

      locations
    end
  end
end
