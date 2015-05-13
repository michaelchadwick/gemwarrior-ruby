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
    
    LOCATION_ID_HOME = 0
    LOCATION_ID_CAVE = 1
    LOCATION_ID_FOREST = 2
    LOCATION_ID_SKYTOWER = 3

    MONSTER_ID_ALEXANDRAT = 0
    MONSTER_ID_AMBEROO = 1
    MONSTER_ID_AMETHYSTLE = 2
    MONSTER_ID_AQUAMARINE = 3

    ITEM_ID_BED = 0
    ITEM_ID_STALACTITE = 1
    ITEM_ID_TREE = 2
    ITEM_ID_CLOUD = 3

    @locations = []
    @monsters = []
    @items = []
    
    def initialize
      @locations = init_locations
      @monsters = init_monsters
    end

    def init_locations
      @locations = []
      @locations.push(Location.new(LOCATION_ID_HOME, "Home", "The little, unimportant, decrepit hut that you live in."))
      @locations.push(Location.new(LOCATION_ID_CAVE, "Cave", "A nearby, dank cavern, filled with stacktites, stonemites, and rocksites."))
      @locations.push(Location.new(LOCATION_ID_FOREST, "Forest", "Trees exist here, in droves."))
      @locations.push(Location.new(LOCATION_ID_SKYTOWER, "Emerald's Sky Tower", "The craziest guy that ever existed is around here somewhere amongst the cloud floors, snow walls, and ethereal vibe."))
    end
    
    def init_monsters
      @monsters = []
      @monsters.push(Monster.new(MONSTER_ID_ALEXANDRAT, "Alexandrat", "Tiny, but fierce, color-changing rodent."))
      @monsters.push(Monster.new(MONSTER_ID_AMBEROO, "Amberoo", "Fossilized and jumping around like an adorably dangerous threat from the past."))
      @monsters.push(Monster.new(MONSTER_ID_AMETHYSTLE, "Amethystle", "Sober and contemplative, it moves with purplish tentacles swaying in the breeze."))
      @monsters.push(Monster.new(MONSTER_ID_AQUAMARINE, "Aquamarine", "It is but one of the few, proud, and underwater assassins."))
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

  end
end