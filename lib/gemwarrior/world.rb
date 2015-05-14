# lib/gemwarrior/world.rb
# World where the locations, monsters, items, etc. exist

require_relative 'constants'
require_relative 'location'
require_relative 'monster'
require_relative 'item'

module Gemwarrior
  class World
    private
    
    def init_monsters
      @monsters = []
      @monsters.push(Monster.new(
          MOB_ID_ALEXANDRAT, 
          MOB_NAME_ALEXANDRAT, 
          MOB_DESC_ALEXANDRAT
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_AMBEROO, 
          MOB_NAME_AMBEROO, 
          MOB_DESC_AMBEROO
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_AMETHYSTLE, 
          MOB_NAME_AMETHYSTLE, 
          MOB_DESC_AMETHYSTLE
        )
      )
      @monsters.push(Monster.new(
        MOB_ID_AQUAMARINE, 
        MOB_NAME_AQUAMARINE, 
        MOB_DESC_AQUAMARINE
      )
    )
    end
    
    def init_items
      @items = []
      @items.push(Item.new(
          ITEM_ID_STONE, 
          ITEM_NAME_STONE, 
          ITEM_DESC_STONE
        )
      )
      @items.push(Item.new(
          ITEM_ID_BED, 
          ITEM_NAME_BED, 
          ITEM_DESC_BED
        )
      )
      @items.push(Item.new(
          ITEM_ID_STALACTITE, 
          ITEM_NAME_STALACTITE, 
          ITEM_DESC_STALACTITE
        )
      )
      @items.push(Item.new(
          ITEM_ID_FEATHER, 
          ITEM_NAME_FEATHER, 
          ITEM_DESC_FEATHER
        )
      )
      @items.push(Item.new(
          ITEM_ID_GUN, 
          ITEM_NAME_GUN, 
          ITEM_DESC_GUN
        )
      )
    end
  
    def init_locations
      @locations = []
      @locations.push(Location.new(
          LOC_ID_HOME, 
          LOC_NAME_HOME, 
          LOC_DESC_HOME, 
          LOC_CONNECTIONS_HOME,
          [item_by_id(0), item_by_id(1)]
        )
      )
      @locations.push(Location.new(
          LOC_ID_CAVE, 
          LOC_NAME_CAVE, 
          LOC_DESC_CAVE,
          LOC_CONNECTIONS_CAVE,
          [item_by_id(2)]
        )
      )
      @locations.push(Location.new(
          LOC_ID_FOREST, 
          LOC_NAME_FOREST, 
          LOC_DESC_FOREST,
          LOC_CONNECTIONS_FOREST,
          [item_by_id(3)]
        )
      )
      @locations.push(Location.new(
          LOC_ID_SKYTOWER, 
          LOC_NAME_SKYTOWER, 
          LOC_DESC_SKYTOWER,
          LOC_CONNECTIONS_SKYTOWER,
          [item_by_id(4)]
        )
      )
    end
  
    public
  
    attr_reader   :locations
    attr_accessor :player
  
    def initialize
      @monsters = init_monsters
      @items = init_items
      @locations = init_locations
      @player = nil
    end

    def item_by_id(id)
      @items.each do |item|
        if item.id.to_i.equal? id
          return item
        end
      end
      return nil
    end
    
    def list_locations
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

    def list_monsters
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