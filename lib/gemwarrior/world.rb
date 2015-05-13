# lib/gemwarrior/world.rb
# World where the locations, monsters, items, etc. exist

require 'highline'
require 'cli-console'

require_relative 'constants'
require_relative 'location'
require_relative 'monster'
require_relative 'gwui'

module Gemwarrior
  class World

    @locations = []
    @monsters = []
    @items = []

    def initialize
      @locations = init_locations
      @monsters = init_monsters
    end

    def init_locations
      @locations = []
      @locations.push(Location.new(LOCATION_ID_HOME, LOCATION_NAME_HOME, LOCATION_DESC_HOME))
      @locations.push(Location.new(LOCATION_ID_CAVE, LOCATION_NAME_CAVE, LOCATION_DESC_CAVE))
      @locations.push(Location.new(LOCATION_ID_FOREST, LOCATION_NAME_FOREST, LOCATION_DESC_FOREST))
      @locations.push(Location.new(LOCATION_ID_SKYTOWER, LOCATION_NAME_SKYTOWER, LOCATION_DESC_SKYTOWER))
    end
    
    def init_monsters
      @monsters = []
      @monsters.push(Monster.new(MONSTER_ID_ALEXANDRAT, MONSTER_NAME_ALEXANDRAT, MONSTER_DESC_ALEXANDRAT))
      @monsters.push(Monster.new(MONSTER_ID_AMBEROO, MONSTER_NAME_AMBEROO, MONSTER_DESC_AMBEROO))
      @monsters.push(Monster.new(MONSTER_ID_AMETHYSTLE, MONSTER_NAME_AMETHYSTLE, MONSTER_DESC_AMETHYSTLE))
      @monsters.push(Monster.new(MONSTER_ID_AQUAMARINE, MONSTER_NAME_AQUAMARINE, MONSTER_DESC_AQUAMARINE))
    end
    
    def locations
      world_locations = []
      @locations.each do |loc|
        world_locations.push(loc.name)
      end
      puts "The world consists of #{world_locations.join(', ')}"
    end
  
    def loc_by_id(id)
      @locations.each do |loc|
        if loc.id.to_i.equal? id
          return loc
        end
      end
      return nil
    end

    def monsters
      world_monsters = []
      @monsters.each do |mob|
        world_monsters.push(mob.name)
      end
      puts "The world's monsters consist of #{world_monsters.join(', ')}"
    end
    
    def mob_by_id(id)
      @monsters.each do |mob|
        if mob.id.to_i.equal? id
          return mob
        end
      end
      return nil
    end
  end
end