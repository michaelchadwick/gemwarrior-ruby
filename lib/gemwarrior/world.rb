# lib/gemwarrior/world.rb
# World where the locations, monsters, items, etc. exist

require_relative 'constants'
require_relative 'monster'
require_relative 'item'
require_relative 'location'

module Gemwarrior
  class World
    private

    include Entities::Monsters
    include Entities::Items
    include Entities::Locations
    
    def init_monsters
      @monsters = []
      @monsters.push(Monster.new(
          MOB_ID_ALEXANDRAT, 
          MOB_NAME_ALEXANDRAT, 
          MOB_DESC_ALEXANDRAT,
          'ugly', 
          'gnarled', 
          'unsurprisingly unchipper', 
          MOB_LEVEL_ALEXANDRAT
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_AMBEROO, 
          MOB_NAME_AMBEROO, 
          MOB_DESC_AMBEROO,
          'punchy', 
          'balled', 
          'jumpy',
          MOB_LEVEL_AMBEROO
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_AMETHYSTLE, 
          MOB_NAME_AMETHYSTLE, 
          MOB_DESC_AMETHYSTLE,
          'sharp', 
          'loose', 
          'mesmerizing',
          MOB_LEVEL_AMETHYSTLE
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_AQUAMARINE, 
          MOB_NAME_AQUAMARINE, 
          MOB_DESC_AQUAMARINE,
          'strained', 
          'hairy', 
          'tempered',
          MOB_LEVEL_AQUAMARINE
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_APATIGER, 
          MOB_NAME_APATIGER, 
          MOB_DESC_APATIGER,
          'calloused', 
          'soft', 
          'apathetic',
          MOB_LEVEL_APATIGER
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_BLOODSTORM, 
          MOB_NAME_BLOODSTORM, 
          MOB_DESC_BLOODSTORM,
          'bloody', 
          'bloody', 
          'boiling',
          MOB_LEVEL_BLOODSTORM
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_CITRINAGA, 
          MOB_NAME_CITRINAGA, 
          MOB_DESC_CITRINAGA,
          'shiny', 
          'glistening', 
          'staid',
          MOB_LEVEL_CITRINAGA
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_CORALIZ, 
          MOB_NAME_CORALIZ, 
          MOB_DESC_CORALIZ,
          'spotted', 
          'slippery', 
          'emotionless',
          MOB_LEVEL_CORALIZ
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_CUBICAT, 
          MOB_NAME_CUBICAT, 
          MOB_DESC_CUBICAT,
          'striking', 
          'grippy', 
          'salacious',
          MOB_LEVEL_CUBICAT
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_DIAMAN, 
          MOB_NAME_DIAMAN, 
          MOB_DESC_DIAMAN,
          'bright', 
          'jagged', 
          'adamant',
          MOB_LEVEL_DIAMAN
        )
      )
    end
    
    def init_items
      @items = []
      @items.push(Item.new(
          ITEM_ID_STONE, 
          ITEM_NAME_STONE, 
          ITEM_DESC_STONE,
          true
        )
      )
      @items.push(Item.new(
          ITEM_ID_BED, 
          ITEM_NAME_BED, 
          ITEM_DESC_BED,
          false
        )
      )
      @items.push(Item.new(
          ITEM_ID_STALACTITE, 
          ITEM_NAME_STALACTITE, 
          ITEM_DESC_STALACTITE,
          true
        )
      )
      @items.push(Item.new(
          ITEM_ID_FEATHER, 
          ITEM_NAME_FEATHER, 
          ITEM_DESC_FEATHER,
          true
        )
      )
      @items.push(Item.new(
          ITEM_ID_GUN, 
          ITEM_NAME_GUN, 
          ITEM_DESC_GUN,
          true
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
          :none,
          [item_by_id(0), item_by_id(1)],
          @monsters
        )
      )
      @locations.push(Location.new(
          LOC_ID_CAVE_ENTRANCE, 
          LOC_NAME_CAVE_ENTRANCE, 
          LOC_DESC_CAVE_ENTRANCE,
          LOC_CONNECTIONS_CAVE_ENTRANCE,
          :low,
          [],
          @monsters
        )
      )
      @locations.push(Location.new(
          LOC_ID_CAVE_ROOM1, 
          LOC_NAME_CAVE_ROOM1, 
          LOC_DESC_CAVE_ROOM1,
          LOC_CONNECTIONS_CAVE_ROOM1,
          :moderate,
          [item_by_id(2)],
          @monsters
        )
      )
      @locations.push(Location.new(
          LOC_ID_FOREST, 
          LOC_NAME_FOREST, 
          LOC_DESC_FOREST,
          LOC_CONNECTIONS_FOREST,
          :low,
          [item_by_id(3)],
          @monsters
        )
      )
      @locations.push(Location.new(
          LOC_ID_SKYTOWER, 
          LOC_NAME_SKYTOWER, 
          LOC_DESC_SKYTOWER,
          LOC_CONNECTIONS_SKYTOWER,
          :high,
          [item_by_id(4)],
          @monsters
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
