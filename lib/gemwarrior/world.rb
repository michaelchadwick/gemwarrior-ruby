# lib/gemwarrior/world.rb
# World where the locations, monsters, items, etc. exist

require_relative 'entities/monster'
require_relative 'entities/item'
require_relative 'entities/location'
require_relative 'defaults'

module Gemwarrior
  class World
    # CONSTANTS
    ## DEFAULTS
    include Entities::Monsters
    include Entities::Items
    include Entities::Locations
    
    ## ERRORS
    ERROR_LIST_PARAM_INVALID = 'That isn\'t something that can be listed.'
  
    attr_accessor :monsters, :items, :locations, :player
  
    def initialize
      self.monsters = init_monsters
      self.items = init_items
      self.locations = init_locations
      self.player = nil
    end

    def all_vars
      puts "======================\n"
      puts "All Variables in World\n"
      puts "======================\n"
      puts "#{list("players", true)}\n"
      puts "#{list("monsters", true)}\n\n"
      puts "#{list("items", true)}\n\n"
      puts "#{list("locations", true)}\n"
    end
    
    def list(param, details = false)
      case param
      when 'players'
        puts '[PLAYERS]'
        player.check_self(false)
      when 'monsters'
        puts '[MONSTERS]'
        if details
          return monsters.map { |m| print m.describe }
        else
          ">> #{monsters.map(&:name).join(', ')}"
        end
      when 'items'
        puts '[ITEMS]'
        if details
          items.map { |i| print i.status }
        else
          ">> #{items.map(&:name).join(', ')}"
        end
      when 'locations'
        puts '[LOCATIONS]'
        if details
          locations.map { |l| print l.status }
        else
          ">> #{locations.map(&:name).join(', ')}"
        end
      else
        ERROR_LIST_PARAM_INVALID
      end
    end
    
    def mob_by_id(id)
      monsters.each do |mob|
        if mob.id.to_i.equal? id
          return mob
        end
      end
      return nil
    end
    
    def item_by_id(id)
      items.each do |item|
        if item.id.to_i.equal? id
          return item
        end
      end
      return nil
    end

    def loc_by_id(id)
      locations.each do |loc|
        if loc.id.to_i.equal? id
          return loc
        end
      end
      return nil
    end
 
    private
    
    def init_monsters
      monsters = []
      monsters.push(Monster.new({
          :id           => MOB_ID_ALEXANDRAT, 
          :name         => MOB_NAME_ALEXANDRAT, 
          :description  => MOB_DESC_ALEXANDRAT,
          :face         => 'ugly', 
          :hands        => 'gnarled', 
          :mood         => 'unsurprisingly unchipper', 
          :level        => (MOB_LEVEL_ALEXANDRAT * 1.5).floor,
          :hp_cur       => (MOB_LEVEL_ALEXANDRAT * 4.25).floor,
          :hp_max       => (MOB_LEVEL_ALEXANDRAT * 4.25).floor,
          :atk_lo       => (MOB_LEVEL_ALEXANDRAT * 1.25).floor,
          :atk_hi       => MOB_LEVEL_ALEXANDRAT * 2,
          :dexterity    => MOB_DEXTERITY_ALEXANDRAT,
          :inventory    => Inventory.new,
          :rox_to_give  => rand(0..10),
          :xp_to_give   => MOB_LEVEL_ALEXANDRAT * rand(1..2),
          :battlecry    => MOB_BATTLECRY_ALEXANDRAT
        })
      )
      monsters.push(Monster.new({
          :id           => MOB_ID_AMBEROO, 
          :name         => MOB_NAME_AMBEROO, 
          :description  => MOB_DESC_AMBEROO,
          :face         => 'punchy', 
          :hands        => 'balled', 
          :mood         => 'jumpy',
          :level        => (MOB_LEVEL_AMBEROO * 1.5).floor,
          :hp_cur       => (MOB_LEVEL_AMBEROO * 4.5).floor,
          :hp_max       => (MOB_LEVEL_AMBEROO * 4.5).floor,
          :atk_lo       => (MOB_LEVEL_AMBEROO * 1.25).floor,
          :atk_hi       => MOB_LEVEL_AMBEROO * 2,
          :dexterity    => MOB_DEXTERITY_AMBEROO,
          :inventory    => Inventory.new,
          :rox_to_give  => rand(0..10),
          :xp_to_give   => MOB_LEVEL_AMBEROO * rand(1..2),
          :battlecry    => MOB_BATTLECRY_AMBEROO
        })
      )
      monsters.push(Monster.new({
          :id           => MOB_ID_AMETHYSTLE, 
          :name         => MOB_NAME_AMETHYSTLE, 
          :description  => MOB_DESC_AMETHYSTLE,
          :face         => 'sharp', 
          :hands        => 'loose', 
          :mood         => 'mesmerizing',
          :level        => MOB_LEVEL_AMETHYSTLE,
          :hp_cur       => MOB_LEVEL_AMETHYSTLE * 5,
          :hp_max       => MOB_LEVEL_AMETHYSTLE * 5,
          :atk_lo       => (MOB_LEVEL_AMETHYSTLE * 1.25).floor,
          :atk_hi       => MOB_LEVEL_AMETHYSTLE * 2,
          :dexterity    => MOB_DEXTERITY_AMETHYSTLE,
          :inventory    => Inventory.new,
          :rox_to_give  => rand(0..10),
          :xp_to_give   => MOB_LEVEL_AMETHYSTLE * rand(1..2),
          :battlecry    => MOB_BATTLECRY_AMETHYSTLE
        })
      )
      monsters.push(Monster.new({
          :id           => MOB_ID_APATIGER, 
          :name         => MOB_NAME_APATIGER, 
          :description  => MOB_DESC_APATIGER,
          :face         => 'calloused', 
          :hands        => 'soft', 
          :mood         => 'apathetic',
          :level        => MOB_LEVEL_APATIGER,
          :hp_cur       => MOB_LEVEL_APATIGER * 5,
          :hp_max       => MOB_LEVEL_APATIGER * 5,
          :atk_lo       => (MOB_LEVEL_APATIGER * 1.25).floor,
          :atk_hi       => MOB_LEVEL_APATIGER * 2,
          :dexterity    => MOB_DEXTERITY_APATIGER,
          :inventory    => Inventory.new,
          :rox_to_give  => rand(0..10),
          :xp_to_give   => MOB_LEVEL_APATIGER * rand(1..2),
          :battlecry    => MOB_BATTLECRY_APATIGER
        })
      )
      monsters.push(Monster.new({
          :id           => MOB_ID_AQUAMARINE, 
          :name         => MOB_NAME_AQUAMARINE, 
          :description  => MOB_DESC_AQUAMARINE,
          :face         => 'strained', 
          :hands        => 'hairy', 
          :mood         => 'tempered',
          :level        => MOB_LEVEL_AQUAMARINE,
          :hp_cur       => MOB_LEVEL_AQUAMARINE * 5,
          :hp_max       => MOB_LEVEL_AQUAMARINE * 5,
          :atk_lo       => (MOB_LEVEL_AQUAMARINE * 1.5).floor,
          :atk_hi       => MOB_LEVEL_AQUAMARINE * 2,
          :dexterity    => MOB_DEXTERITY_AQUAMARINE,
          :inventory    => Inventory.new,
          :rox_to_give  => rand(0..10),
          :xp_to_give   => MOB_LEVEL_AQUAMARINE * rand(1..2),
          :battlecry    => MOB_BATTLECRY_AQUAMARINE
        })
      )
      monsters.push(Monster.new({
          :id           => MOB_ID_BLOODSTORM, 
          :name         => MOB_NAME_BLOODSTORM, 
          :description  => MOB_DESC_BLOODSTORM,
          :face         => 'bloody', 
          :hands        => 'bloody', 
          :mood         => 'boiling',
          :level        => MOB_LEVEL_BLOODSTORM,
          :hp_cur       => MOB_LEVEL_BLOODSTORM * 5,
          :hp_max       => MOB_LEVEL_BLOODSTORM * 5,
          :atk_lo       => (MOB_LEVEL_BLOODSTORM * 1.5).floor,
          :atk_hi       => MOB_LEVEL_BLOODSTORM * 2,
          :dexterity    => MOB_DEXTERITY_BLOODSTORM,
          :inventory    => Inventory.new,
          :rox_to_give  => rand(0..10),
          :xp_to_give   => MOB_LEVEL_BLOODSTORM * rand(2..3),
          :battlecry    => MOB_BATTLECRY_BLOODSTORM
        })
      )
      monsters.push(Monster.new({
          :id           => MOB_ID_CITRINAGA, 
          :name         => MOB_NAME_CITRINAGA, 
          :description  => MOB_DESC_CITRINAGA,
          :face         => 'shiny', 
          :hands        => 'glistening', 
          :mood         => 'staid',
          :level        => MOB_LEVEL_CITRINAGA,
          :hp_cur       => MOB_LEVEL_CITRINAGA * 5,
          :hp_max       => MOB_LEVEL_CITRINAGA * 5,
          :atk_lo       => (MOB_LEVEL_CITRINAGA * 1.3).floor,
          :atk_hi       => MOB_LEVEL_CITRINAGA * 2,
          :dexterity    => MOB_DEXTERITY_CITRINAGA,
          :inventory    => Inventory.new,
          :rox_to_give  => rand(0..10),
          :xp_to_give   => MOB_LEVEL_CITRINAGA * rand(2..3),
          :battlecry    => MOB_BATTLECRY_CITRINAGA
        })
      )
      monsters.push(Monster.new({
          :id           => MOB_ID_CORALIZ, 
          :name         => MOB_NAME_CORALIZ, 
          :description  => MOB_DESC_CORALIZ,
          :face         => 'spotted', 
          :hands        => 'slippery', 
          :mood         => 'emotionless',
          :level        => MOB_LEVEL_CORALIZ,
          :hp_cur       => MOB_LEVEL_CORALIZ * 5,
          :hp_max       => MOB_LEVEL_CORALIZ * 5,
          :atk_lo       => (MOB_LEVEL_CORALIZ * 1.5).floor,
          :atk_hi       => MOB_LEVEL_CORALIZ * 2,
          :dexterity    => MOB_DEXTERITY_CORALIZ,
          :inventory    => Inventory.new,
          :rox_to_give  => rand(0..10),
          :xp_to_give   => MOB_LEVEL_CORALIZ * rand(2..3),
          :battlecry    => MOB_BATTLECRY_CORALIZ
        })
      )
      monsters.push(Monster.new({
          :id           => MOB_ID_CUBICAT, 
          :name         => MOB_NAME_CUBICAT, 
          :description  => MOB_DESC_CUBICAT,
          :face         => 'striking', 
          :hands        => 'grippy', 
          :mood         => 'salacious',
          :level        => MOB_LEVEL_CUBICAT,
          :hp_cur       => MOB_LEVEL_CUBICAT * 5,
          :hp_max       => MOB_LEVEL_CUBICAT * 5,
          :atk_lo       => (MOB_LEVEL_CUBICAT * 1.75).floor,
          :atk_hi       => MOB_LEVEL_CUBICAT * 2,
          :dexterity    => MOB_DEXTERITY_CUBICAT,
          :inventory    => Inventory.new,
          :rox_to_give  => rand(0..10),
          :xp_to_give   => MOB_LEVEL_CUBICAT * rand(3..4),
          :battlecry    => MOB_BATTLECRY_CUBICAT
        })
      )
      monsters.push(Monster.new({
          :id           => MOB_ID_DIAMAN, 
          :name         => MOB_NAME_DIAMAN, 
          :description  => MOB_DESC_DIAMAN,
          :face         => 'bright', 
          :hands        => 'jagged', 
          :mood         => 'adamant',
          :level        => MOB_LEVEL_DIAMAN,
          :hp_cur       => MOB_LEVEL_DIAMAN * 5,
          :hp_max       => MOB_LEVEL_DIAMAN * 5,
          :atk_lo       => (MOB_LEVEL_DIAMAN * 1.75).floor,
          :atk_hi       => MOB_LEVEL_DIAMAN * 2,
          :dexterity    => MOB_DEXTERITY_DIAMAN,
          :inventory    => Inventory.new,
          :rox_to_give  => rand(0..10),
          :xp_to_give   => MOB_LEVEL_DIAMAN * rand(3..5),
          :battlecry    => MOB_BATTLECRY_DIAMAN
        })
      )
    end
    
    def init_items
      items = []
      items.push(Item.new({
          :id           => ITEM_ID_STONE, 
          :name         => ITEM_NAME_STONE, 
          :description  => ITEM_DESC_STONE,
          :atk_lo       => ITEM_ATK_LO_STONE,
          :atk_hi       => ITEM_ATK_HI_STONE,
          :takeable     => true,
          :equippable   => true
        })
      )
      items.push(Item.new({
          :id           => ITEM_ID_BED, 
          :name         => ITEM_NAME_BED, 
          :description  => ITEM_DESC_BED,
          :atk_lo       => ITEM_ATK_LO_BED,
          :atk_hi       => ITEM_ATK_HI_BED,
          :takeable     => false,
          :equippable   => false
        })
      )
      items.push(Item.new({
          :id           => ITEM_ID_STALACTITE, 
          :name         => ITEM_NAME_STALACTITE, 
          :description  => ITEM_DESC_STALACTITE,
          :atk_lo       => ITEM_ATK_LO_STALACTITE,
          :atk_hi       => ITEM_ATK_HI_STALACTITE,
          :takeable     => true,
          :equippable   => true
        })
      )
      items.push(Item.new({
          :id           => ITEM_ID_FEATHER, 
          :name         => ITEM_NAME_FEATHER, 
          :description  => ITEM_DESC_FEATHER,
          :atk_lo       => ITEM_ATK_LO_FEATHER,
          :atk_hi       => ITEM_ATK_HI_FEATHER,
          :takeable     => true,
          :equippable   => false
        })
      )
      items.push(Item.new({
          :id           => ITEM_ID_GUN, 
          :name         => ITEM_NAME_GUN, 
          :description  => ITEM_DESC_GUN,
          :atk_lo       => ITEM_ATK_LO_GUN,
          :atk_hi       => ITEM_ATK_HI_GUN,
          :takeable     => true,
          :equippable   => true
        })
      )
    end
  
    def init_locations
      locations = []
      locations.push(Location.new({
          :id                 => LOC_ID_HOME, 
          :name               => LOC_NAME_HOME, 
          :description        => LOC_DESC_HOME, 
          :locs_connected     => LOC_CONNECTIONS_HOME,
          :danger_level       => :none,
          :items              => [item_by_id(0), item_by_id(1)],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :id                 => LOC_ID_CAVE_ENTRANCE, 
          :name               => LOC_NAME_CAVE_ENTRANCE, 
          :description        => LOC_DESC_CAVE_ENTRANCE,
          :locs_connected     => LOC_CONNECTIONS_CAVE_ENTRANCE,
          :danger_level       => :low,
          :items              => [],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :id                 => LOC_ID_CAVE_ROOM1, 
          :name               => LOC_NAME_CAVE_ROOM1, 
          :description        => LOC_DESC_CAVE_ROOM1,
          :locs_connected     => LOC_CONNECTIONS_CAVE_ROOM1,
          :danger_level       => :moderate,
          :items              => [item_by_id(2)],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :id                 => LOC_ID_FOREST, 
          :name               => LOC_NAME_FOREST, 
          :description        => LOC_DESC_FOREST,
          :locs_connected     => LOC_CONNECTIONS_FOREST,
          :danger_level       => :low,
          :items              => [item_by_id(3)],
          :monsters_available => monsters
        })
      )
      locations.push(Location.new({
          :id                 => LOC_ID_SKYTOWER, 
          :name               => LOC_NAME_SKYTOWER, 
          :description        => LOC_DESC_SKYTOWER,
          :locs_connected     => LOC_CONNECTIONS_SKYTOWER,
          :danger_level       => :assured,
          :items              => [item_by_id(4)],
          :monsters_available => monsters
        })
      )
    end
  end
end
