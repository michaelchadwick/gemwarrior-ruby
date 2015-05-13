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
    def initialize
      @locations = init_locations
      @monsters = init_monsters
      @items = []
    end

    def init_locations
      @locations = []
      @locations.push(Location.new(LOC_ID_HOME, LOC_NAME_HOME, LOC_DESC_HOME))
      @locations.push(Location.new(LOC_ID_CAVE, LOC_NAME_CAVE, LOC_DESC_CAVE))
      @locations.push(Location.new(LOC_ID_FOREST, LOC_NAME_FOREST, LOC_DESC_FOREST))
      @locations.push(Location.new(LOC_ID_SKYTOWER, LOC_NAME_SKYTOWER, LOC_DESC_SKYTOWER))
    end
    
    def init_monsters
      @monsters = []
      @monsters.push(Monster.new(MOB_ID_ALEXANDRAT, MOB_NAME_ALEXANDRAT, MOB_DESC_ALEXANDRAT))
      @monsters.push(Monster.new(MOB_ID_AMBEROO, MOB_NAME_AMBEROO, MOB_DESC_AMBEROO))
      @monsters.push(Monster.new(MOB_ID_AMETHYSTLE, MOB_NAME_AMETHYSTLE, MOB_DESC_AMETHYSTLE))
      @monsters.push(Monster.new(MOB_ID_AQUAMARINE, MOB_NAME_AQUAMARINE, MOB_DESC_AQUAMARINE))
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