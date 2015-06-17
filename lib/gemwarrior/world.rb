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
    ERROR_LOCATION_DESCRIBE_ENTITY_INVALID  = 'You do not see that here.'
  
    attr_accessor :monsters, :locations, :player, :debug_mode, :use_wordnik
  
    def initialize
      self.monsters   = init_monsters
      self.locations  = init_locations
      self.player     = nil
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
      print '  '
      0.upto(WORLD_DIM_WIDTH-1) do
        print '---'
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
        puts "[MONSTERS](#{monsters.length})"
        if details
          monsters.map { |m| print m.describe unless m.is_boss}
          monsters.map { |m| print m.describe if m.is_boss }
          return
        else
          monster_text =  ">> monsters: #{monsters.map(&:name).join(', ')}"
        end
      when 'items'
        item_count = 0
        locations.each do |l|
          l.items.each do |i|
            item_count = item_count + 1
          end
        end
        puts "[ITEMS](#{item_count})"
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
        puts "[LOCATIONS](#{locations.length})"
        if details
          locations.map { |l| print l.status(self.debug_mode) }
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
        if l.name.downcase.eql?(name.downcase)
          return l.coords
        end
      end
      return nil
    end
 
    def describe(point)
      desc_text = ""
      desc_text << "[ #{point.name} ]".colorize(:green)
      
      if debug_mode
        desc_text << " DL[#{point.danger_level.to_s}] MLR[#{point.monster_level_range.to_s}]".colorize(:yellow)
      end
      
      desc_text << "\n"
      desc_text << point.description
      
      point.populate_monsters(self.monsters) unless point.checked_for_monsters?
      
      desc_text << "\n >> Curious object(s): #{point.list_items.join(', ')}" unless point.list_items.empty?
      desc_text << "\n >> Monster(s) abound: #{point.list_monsters.join(', ')}" unless point.list_monsters.empty?
      desc_text << "\n >> Boss(es) abound: #{point.list_bosses.join(', ')}" unless point.list_bosses.empty?
      desc_text << "\n >> Paths: #{point.list_paths.join(', ')}"
      
      if debug_mode
        desc_text << "\n >>> Actionable words: "
        desc_text << point.list_actionable_words.colorize(:white)
      end
      
      return desc_text
    end
    
    def describe_entity(point, entity_name)
      if point.list_items.map{|i| i.downcase}.include?(entity_name)
        point.items.each do |i|
          if i.name.downcase.eql?(entity_name.downcase)
            if debug_mode
              return i.status
            else
              return i.description
            end
          end
        end
      elsif
        if point.list_monsters.map{|m| m.downcase}.include?(entity_name)
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
        if point.list_bosses.map{|b| b.downcase}.include?(entity_name)
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
        if combatant.downcase.eql?(monster_name.downcase)
          return true
        end
      end
      
      return false
    end
 
    private
    
    def init_monsters
      Dir.glob('lib/gemwarrior/entities/monsters/*.rb').each do |item|
        require_relative item[item.index('/', item.index('/')+1)+1..item.length]
      end
      Dir.glob('lib/gemwarrior/entities/monsters/bosses/*.rb').each do |item|
        require_relative item[item.index('/', item.index('/')+1)+1..item.length]
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
        require_relative item[item.index('/', item.index('/')+1)+1..item.length]
      end
      
      locations = []

      locations.push(Location.new({
          :name                 => 'Home', 
          :description          => 'The little, unimportant, decrepit hut that you live in.', 
          :coords               => {:x => 5, :y => 0},
          :locs_connected       => {:north => true, :east => true, :south => false, :west => true},
          :danger_level         => :none,
          :monster_level_range  => nil,
          :items                => [Bed.new, Stone.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Cave (Entrance)', 
          :description          => 'A nearby, dank entrance to a cavern, surely filled with stacktites, stonemites, and rocksites.',
          :coords               => {:x => 6, :y => 0},
          :locs_connected       => {:north => false, :east => true, :south => false, :west => true},
          :danger_level         => :low,
          :monster_level_range  => 1..2,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Cave (Antechamber)', 
          :description          => 'Now inside the cavern, you confirm there are stacktites, stonemites, rocksites, and even some pebblejites.',
          :coords               => {:x => 7, :y => 0},
          :locs_connected       => {:north => true, :east => true, :south => false, :west => true},
          :danger_level         => :moderate,
          :monster_level_range  => 2..3,
          :items                => [Stalactite.new, Stonemite.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Cave (Nook)', 
          :description          => 'A depression in the cave wall casts a shadow over a small rock shelf.',
          :coords               => {:x => 7, :y => 1},
          :locs_connected       => {:north => false, :east => true, :south => true, :west => false},
          :danger_level         => :moderate,
          :monster_level_range  => 2..3,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Cave (Dropoff)', 
          :description          => 'Caves do not usually feature sudden chasms spilling down into an unknowable void, but this one does.',
          :coords               => {:x => 8, :y => 1},
          :locs_connected       => {:north => false, :east => false, :south => true, :west => true},
          :danger_level         => :moderate,
          :monster_level_range  => 2..4,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Cave (Causeway)', 
          :description          => 'Paths lead north and west, but nothing of interest is in this causeway.',
          :coords               => {:x => 8, :y => 0},
          :locs_connected       => {:north => true, :east => false, :south => false, :west => true},
          :danger_level         => :moderate,
          :monster_level_range  => 2..3,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Forest (Southeast)', 
          :description          => 'Trees exist here, in droves.',
          :coords               => {:x => 4, :y => 0},
          :locs_connected       => {:north => true, :east => true, :south => false, :west => false},
          :danger_level         => :low,
          :monster_level_range  => 1..3,
          :items                => [Tree.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Forest (Northeast)', 
          :description          => 'You see much foliage.',
          :coords               => {:x => 4, :y => 1},
          :locs_connected       => {:north => false, :east => false, :south => true, :west => true},
          :danger_level         => :low,
          :monster_level_range  => 1..3,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Forest (Northwest)', 
          :description          => 'The amount of leaves and branches and trunks you can see boggles the mind.',
          :coords               => {:x => 3, :y => 1},
          :locs_connected       => {:north => false, :east => true, :south => true, :west => false},
          :danger_level         => :low,
          :monster_level_range  => 1..3,
          :items                => [Feather.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Forest (Southwest)', 
          :description          => 'While you continue to be impressed at the sheer size of this forest, a clearing appears to open up to the west.',
          :coords               => {:x => 3, :y => 0},
          :locs_connected       => {:north => true, :east => false, :south => false, :west => true},
          :danger_level         => :low,
          :monster_level_range  => 1..3,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Pain Desert (Southeast)', 
          :description          => 'Horrible terribleness emanates from this desolate land of unkind misery.',
          :coords               => {:x => 2, :y => 0},
          :locs_connected       => {:north => true, :east => true, :south => false, :west => true},
          :danger_level         => :assured,
          :monster_level_range  => 5..20,
          :items                => [],
          :bosses_abounding     => [Garynetty.new]
        })
      )
      locations.push(Location.new({
          :name                 => 'Pain Desert (East)', 
          :description          => 'Horrible terribleness emanates from this desolate land of unkind misery.',
          :coords               => {:x => 2, :y => 1},
          :locs_connected       => {:north => false, :east => false, :south => true, :west => true},
          :danger_level         => :assured,
          :monster_level_range  => 5..20,
          :items                => [],
          :bosses_abounding     => [Garynetty.new]
        })
      )
      locations.push(Location.new({
          :name                 => 'Pain Desert (Central)', 
          :description          => 'Horrible terribleness emanates from this desolate land of unkind misery.',
          :coords               => {:x => 1, :y => 1},
          :locs_connected       => {:north => true, :east => true, :south => true, :west => true},
          :danger_level         => :assured,
          :monster_level_range  => 5..20,
          :items                => [],
          :bosses_abounding     => [Garynetty.new]
        })
      )
      locations.push(Location.new({
          :name                 => 'Pain Desert (South)', 
          :description          => 'Horrible terribleness emanates from this desolate land of unkind misery.',
          :coords               => {:x => 1, :y => 0},
          :locs_connected       => {:north => true, :east => true, :south => false, :west => false},
          :danger_level         => :assured,
          :monster_level_range  => 5..20,
          :items                => [],
          :bosses_abounding     => [Garynetty.new]
        })
      )
      locations.push(Location.new({
          :name                 => 'Pain Desert (West)', 
          :description          => 'Horrible terribleness emanates from this desolate land of unkind misery.',
          :coords               => {:x => 0, :y => 1},
          :locs_connected       => {:north => true, :east => true, :south => false, :west => false},
          :danger_level         => :assured,
          :monster_level_range  => 5..20,
          :items                => [],
          :bosses_abounding     => [Garynetty.new]
        })
      )
      locations.push(Location.new({
          :name                 => 'Pain Desert (Northwest)', 
          :description          => 'Horrible terribleness emanates from this desolate land of unkind misery.',
          :coords               => {:x => 0, :y => 2},
          :locs_connected       => {:north => false, :east => true, :south => true, :west => false},
          :danger_level         => :assured,
          :monster_level_range  => 5..20,
          :items                => [],
          :bosses_abounding     => [Garynetty.new]
        })
      )
      locations.push(Location.new({
          :name                 => 'Pain Desert (North)', 
          :description          => 'Horrible terribleness emanates from this desolate land of unkind misery.',
          :coords               => {:x => 1, :y => 2},
          :locs_connected       => {:north => false, :east => false, :south => true, :west => true},
          :danger_level         => :assured,
          :monster_level_range  => 5..20,
          :items                => [],
          :bosses_abounding     => [Garynetty.new]
        })
      )
      locations.push(Location.new({
          :name                 => 'Plains (Outskirts)', 
          :description          => 'A lot of grass and nothing, stretching out northward.',
          :coords               => {:x => 5, :y => 1},
          :locs_connected       => {:north => true, :east => false, :south => true, :west => false},
          :danger_level         => :low,
          :monster_level_range  => 2..3,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Plains (Fields)', 
          :description          => 'Now you\'re plum in the middle of rolling fields.',
          :coords               => {:x => 5, :y => 2},
          :locs_connected       => {:north => true, :east => false, :south => true, :west => false},
          :danger_level         => :low,
          :monster_level_range  => 2..3,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Plains (South of River)', 
          :description          => 'A raging river borders the northern side of this bucolic vista.',
          :coords               => {:x => 5, :y => 3},
          :locs_connected       => {:north => false, :east => false, :south => true, :west => true},
          :danger_level         => :low,
          :monster_level_range  => 2..3,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Plains (South of Bridge)', 
          :description          => 'To the north of these fields lies a bridge that may be crossable.',
          :coords               => {:x => 4, :y => 3},
          :locs_connected       => {:north => true, :east => true, :south => false, :west => true},
          :danger_level         => :low,
          :monster_level_range  => 2..3,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Plains (Hut)', 
          :description          => 'A straw hut sits alone, curiously, in a patch of grass, sticks, and straw.',
          :coords               => {:x => 3, :y => 3},
          :locs_connected       => {:north => false, :east => true, :south => false, :west => false},
          :danger_level         => :none,
          :monster_level_range  => nil,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'River Bridge', 
          :description          => 'Sturdy and safe, this bridge will get you across the otherwise unpassable river you see below.',
          :coords               => {:x => 4, :y => 4},
          :locs_connected       => {:north => true, :east => false, :south => true, :west => false},
          :danger_level         => :moderate,
          :monster_level_range  => 3..5,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Plains (North of Bridge)', 
          :description          => 'North of the river feels similar to south of the river, as you continue to be surrounded by grass and grass and, well, grass.',
          :coords               => {:x => 4, :y => 5},
          :locs_connected       => {:north => false, :east => false, :south => true, :west => true},
          :danger_level         => :low,
          :monster_level_range  => 2..3,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Rock Quarry', 
          :description          => 'Piles of rocks, both big and small, are placed here and there, a testament to someone\'s surely back-breaking labor.',
          :coords               => {:x => 3, :y => 5},
          :locs_connected       => {:north => false, :east => true, :south => false, :west => false},
          :danger_level         => :moderate,
          :monster_level_range  => 3..4,
          :items                => [Gun.new, TowerSwitch.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Sky Tower (Entryway)', 
          :description          => 'You feel unsettled as you gaze upon the wondrous proportions of Emerald\'s home.',
          :coords               => {:x => 8, :y => 6},
          :locs_connected       => {:north => true, :east => true, :south => false, :west => true},
          :danger_level         => :moderate,
          :monster_level_range  => 3..4,
          :items                => [FloorTile.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Sky Tower (Cloud Garden)', 
          :description          => 'A perfectly-maintained array of wispy flowers and other ethereal plantlife contained within a cumulonimbus barrier.',
          :coords               => {:x => 8, :y => 7},
          :locs_connected       => {:north => false, :east => false, :south => true, :west => false},
          :danger_level         => :moderate,
          :monster_level_range  => 3..4,
          :items                => [Flower.new, Keystone.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Sky Tower (Armory)', 
          :description          => 'Weapons of all kinds litter the ground and are hung on hooks from the wall. Tower assailants beware/rejoice!',
          :coords               => {:x => 7, :y => 6},
          :locs_connected       => {:north => true, :east => true, :south => false, :west => false},
          :danger_level         => :moderate,
          :monster_level_range  => 3..4,
          :items                => [Dehumidifier.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Sky Tower (West Hallway)', 
          :description          => 'The hallway seems to stretch on for days.',
          :coords               => {:x => 7, :y => 7},
          :locs_connected       => {:north => true, :east => false, :south => true, :west => false},
          :danger_level         => :moderate,
          :monster_level_range  => 3..4,
          :items                => [Flower.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Sky Tower (Waterfalls)', 
          :description          => 'The seemingly neverending deluge of water causes this room to be quite loud, yet pretty.',
          :coords               => {:x => 7, :y => 8},
          :locs_connected       => {:north => true, :east => true, :south => false, :west => false},
          :danger_level         => :moderate,
          :monster_level_range  => 3..4,
          :items                => [Waterfall.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Sky Tower (Massive Door)', 
          :description          => 'Before you lies a massive collection of cumulus clouds that form into a seemingly impenetrable door, beyond which may well be your doom.',
          :coords               => {:x => 8, :y => 8},
          :locs_connected       => {:north => false, :east => true, :south => false, :west => true},
          :danger_level         => :moderate,
          :monster_level_range  => 4..5,
          :items                => [MassiveDoor.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Sky Tower (Throne Room)', 
          :description          => 'There, on a mighty seat made of broken dreams, sits Emerald himself, staring at you coldly, silently.',
          :coords               => {:x => 8, :y => 9},
          :locs_connected       => {:north => false, :east => false, :south => true, :west => false},
          :danger_level         => :high,
          :monster_level_range  => 5..7,
          :items                => [Throne.new],
          :bosses_abounding     => [Emerald.new]
        })
      )
      locations.push(Location.new({
          :name                 => 'Sky Tower (Lounge)', 
          :description          => 'Nothing but a simple couch, which looks very comfortable, exists in this corner of the tower.',
          :coords               => {:x => 9, :y => 8},
          :locs_connected       => {:north => false, :east => false, :south => true, :west => true},
          :danger_level         => :moderate,
          :monster_level_range  => 3..4,
          :items                => [Couch.new],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Sky Tower (East Hallway)', 
          :description          => 'Longish and neverending is what you might say about this stretch of the tower.',
          :coords               => {:x => 9, :y => 7},
          :locs_connected       => {:north => true, :east => false, :south => true, :west => false},
          :danger_level         => :moderate,
          :monster_level_range  => 3..4,
          :items                => [],
          :bosses_abounding     => []
        })
      )
      locations.push(Location.new({
          :name                 => 'Sky Tower (Kitchen)', 
          :description          => 'This kitchen looks well-used, as appliances abound, and leftover food sits atop counters.',
          :coords               => {:x => 9, :y => 6},
          :locs_connected       => {:north => true, :east => false, :south => false, :west => true},
          :danger_level         => :moderate,
          :monster_level_range  => 3..4,
          :items                => [Apple.new, Cup.new],
          :bosses_abounding     => []
        })
      )
    end
  end
end
