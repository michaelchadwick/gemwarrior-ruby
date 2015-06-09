# lib/gemwarrior/world.rb
# World where the locations, monsters, items, etc. exist

require_relative 'entities/item'
require_relative 'entities/location'

module Gemwarrior
  class World
    # CONSTANTS
    ## WORLD DIMENSIONS
    WORLD_DIM_WIDTH   = 10
    WORLD_DIM_HEIGHT  = 10
    
    ## ERRORS
    ERROR_LIST_PARAM_INVALID = 'That is not something that can be listed.'
  
    attr_accessor :monsters, :locations, :player
  
    def initialize
      self.monsters = init_monsters
      self.locations = init_locations
      self.player = nil
    end

    def print_all_vars
      puts "======================\n"
      puts "All Variables in World\n"
      puts "======================\n"
      puts "#{list("players", true)}\n"
      puts "#{list("monsters", true)}\n\n"
      puts "#{list("items", true)}\n\n"
      puts "#{list("locations", true)}\n"
    end

    def print_map
      0.upto(WORLD_DIM_HEIGHT-1) do |count_y|
        print '  '
        0.upto(WORLD_DIM_WIDTH-1) do
          print '---'
        end
        print "\n"
        print "#{(WORLD_DIM_HEIGHT-1) - count_y} "
        0.upto(WORLD_DIM_WIDTH-1) do |count_x|
          cur_map_coords = {:x => count_x, :y => (WORLD_DIM_HEIGHT-1) - count_y}
          if self.player.cur_coords.eql?(cur_map_coords)
            print '|O|'
          elsif location_by_coords(cur_map_coords)
            print '|X|'
          else
            print '| |'
          end
        end
        print "\n"
      end
      puts
      print '   '
      0.upto(WORLD_DIM_WIDTH-1) do |count_x|
        print "#{count_x}  "
      end
      return
    end

    def list(param, details = false)
      case param
      when 'players'
        puts '[PLAYERS]'
        player.check_self(false)
      when 'monsters'
        puts '[MONSTERS]'
        if details
          monsters.map { |m| print m.describe }
          return
        else
          ">> #{monsters.map(&:name).join(', ')}"
        end
      when 'items'
        puts '[ITEMS]'
        if details
          locations.each do |l|
            l.items.map { |i| print i.status }
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
        puts '[LOCATIONS]'
        if details
          locations.map { |l| print l.status }
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
        if l.coords.eql?(coords)
          return l
        end
      end
      return nil
    end
    
    def location_coords_by_name(name)
      locations.each do |l|
        if l.name.eql? name
          return l.coords
        end
      end
      return nil
    end
 
    def describe(point)
      desc_text = ""
      desc_text << "[ #{point.name} ]\n"
      desc_text << point.description
      unless point.checked_for_monsters?
        point.populate_monsters
      end
      unless point.list_items.nil?
        desc_text << point.list_items
      end
      unless point.list_monsters.nil?
        desc_text << point.list_monsters
      end
      desc_text << point.list_paths
    end
    
    def describe_entity(point, entity_name)
      if point.items.map(&:name).include?(entity_name)
        point.items.each do |i|
          if i.name.eql?(entity_name)
            return "#{i.description}"
          end
        end
      elsif
        if point.monsters_abounding.map(&:name).include?(entity_name)
          point.monsters_abounding.each do |m|
            if m.name.eql?(entity_name)
              return "#{m.description}"
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
      location_by_coords(player.cur_coords).monsters_abounding.map(&:name).include?(monster_name.downcase)
    end
 
    private
    
    def init_monsters
      require_relative 'entities/monsters/alexandrat'
      require_relative 'entities/monsters/amberoo'
      require_relative 'entities/monsters/amethystle'
      require_relative 'entities/monsters/apatiger'
      require_relative 'entities/monsters/aquamarine'
      require_relative 'entities/monsters/bloodstorm'
      require_relative 'entities/monsters/citrinaga'
      require_relative 'entities/monsters/coraliz'
      require_relative 'entities/monsters/cubicat'
      require_relative 'entities/monsters/diaman'
      
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
        Diaman.new
      ]
    end

    def init_locations
      require_relative 'entities/items/bed'
      require_relative 'entities/items/feather'
      require_relative 'entities/items/gun'
      require_relative 'entities/items/stalactite'
      require_relative 'entities/items/stonemite'
      require_relative 'entities/items/stone'
      require_relative 'entities/items/tree'
      
      locations = []

      locations.push(Location.new({
          :name               => 'Home', 
          :description        => 'The little, unimportant, decrepit hut that you live in.', 
          :coords             => {:x => 5, :y => 0},
          :locs_connected     => {:north => true, :east => true, :south => false, :west => true},
          :danger_level       => :none,
          :items              => [Bed.new, Stone.new],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :name               => 'Cave (Entrance)', 
          :description        => 'A nearby, dank entrance to a cavern, surely filled with stacktites, stonemites, and rocksites.',
          :coords             => {:x => 6, :y => 0},
          :locs_connected     => {:north => false, :east => true, :south => false, :west => true},
          :danger_level       => :low,
          :items              => [],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :name               => 'Cave (Foyer)', 
          :description        => 'Now inside the entrance to the cavern, you confirm that there are stacktites, stonemites, rocksites, and even one or two pebblejites.',
          :coords             => {:x => 7, :y => 0},
          :locs_connected     => {:north => true, :east => true, :south => false, :west => true},
          :danger_level       => :moderate,
          :items              => [Stalactite.new, Stonemite.new],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :name               => 'Cave (Nook)', 
          :description        => 'A depression in the cave wall casts a shadow over a small rock shelf.',
          :coords             => {:x => 7, :y => 1},
          :locs_connected     => {:north => false, :east => true, :south => true, :west => false},
          :danger_level       => :moderate,
          :items              => [],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :name               => 'Cave (Dropoff)', 
          :description        => 'Caves do not usually feature sudden chasms spilling down into an unknowable void, but this one does.',
          :coords             => {:x => 8, :y => 1},
          :locs_connected     => {:north => false, :east => false, :south => true, :west => true},
          :danger_level       => :moderate,
          :items              => [],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :name               => 'Cave (Causeway)', 
          :description        => 'Paths lead north and west, but nothing of interest is in this causeway.',
          :coords             => {:x => 8, :y => 0},
          :locs_connected     => {:north => true, :east => false, :south => false, :west => true},
          :danger_level       => :moderate,
          :items              => [],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :name               => 'Forest', 
          :description        => 'Trees exist here, in droves.',
          :coords             => {:x => 4, :y => 0},
          :locs_connected     => {:north => false, :east => true, :south => false, :west => false},
          :danger_level       => :low,
          :items              => [Feather.new, Tree.new],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :name               => 'Plains', 
          :description        => 'A lot of grass and nothing, but you see a mysterious tower further north, and your home to the south.',
          :coords             => {:x => 5, :y => 1},
          :locs_connected     => {:north => true, :east => false, :south => true, :west => false},
          :danger_level       => :low,
          :items              => [],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :name               => 'Emerald\'s Sky Tower', 
          :description        => 'The craziest guy that ever existed is around here somewhere amongst the cloud floors, snow walls, and ethereal vibe.',
          :coords             => {:x => 5, :y => 2},
          :locs_connected     => {:north => false, :east => false, :south => true, :west => false},
          :danger_level       => :assured,
          :items              => [Gun.new],
          :monsters_available => monsters
        })
      )
    end
  end
end
