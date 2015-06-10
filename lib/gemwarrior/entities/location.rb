# lib/gemwarrior/entities/location.rb
# Place in the game

require_relative 'entity'

module Gemwarrior
  class Location < Entity
    # CONSTANTS
    ## HASHES
    DANGER_LEVEL = {:none => 0, :low => 15, :moderate => 30, :high => 55, :assured => 100}
    
    ## ERRORS
    ERROR_LOCATION_ITEM_REMOVE_INVALID      = 'That item cannot be removed as it does not exist here.'

    attr_accessor :coords, :locs_connected, :danger_level, :items, 
                  :monsters_abounding, :bosses_abounding, :checked_for_monsters
  
    def initialize(options)
      self.name                 = options.fetch(:name)
      self.description          = options.fetch(:description)
      self.coords               = options.fetch(:coords)
      self.locs_connected       = options.fetch(:locs_connected)
      self.danger_level         = options.fetch(:danger_level)
      self.items                = options.fetch(:items)
      self.monsters_abounding   = []
      self.bosses_abounding     = options[:bosses_abounding]
      self.checked_for_monsters = false
    end
    
    def status
      status_text =  name.ljust(26).upcase
      status_text << coords.values.to_a.to_s
      status_text << " #{description}\n"
    end
    
    def remove_item(item_name)
      if items.map(&:name).include?(item_name)
        items.reject! { |item| item.name == item_name }
      else
        ERROR_LOCATION_ITEM_REMOVE_INVALID
      end
    end

    def remove_monster(name)
      monsters_abounding.reject! { |monster| monster.name == name }
    end
    
    def has_loc_to_the?(direction)
      case direction
      when 'n'
        direction = 'north'
      when 'e'
        direction = 'east'
      when 's'
        direction = 'south'
      when 'w'
        direction = 'west'
      end
      locs_connected[direction.to_sym]
    end

    def monster_by_name(monster_name)
      monsters_list = monsters_abounding | bosses_abounding

      monsters_list.each do |m|
        if m.name.downcase.eql?(monster_name.downcase)
          return m.clone
        end
      end
    end
    
    def checked_for_monsters?
      checked_for_monsters
    end
    
    def has_monster?
      found = false
      unless danger_level.eql?(:none)
        max = DANGER_LEVEL[danger_level]
        trigger_values = 0..max
        actual_value = rand(1..100)
        
        if trigger_values.include?(actual_value)
          found = true
        end
      end
      return found
    end
    
    def list_items
      return "\n >> Curious object(s): #{items.map(&:name).join(', ')}" if items.length > 0
    end
    
    def list_monsters
      return "\n >> Monster(s) abound: #{monsters_abounding.map(&:name).join(', ')}" if monsters_abounding.length > 0
    end
    
    def list_bosses
      return "\n >> Boss(es) abound: #{bosses_abounding.map(&:name).join(', ')}" if bosses_abounding.length > 0
    end
    
    def list_paths
      valid_paths = []
      locs_connected.each do |key, value|
        if value
          valid_paths.push(key.to_s)
        end
      end
      return "\n >> Paths: #{valid_paths.join(', ')}"
    end
    
    def populate_monsters(monsters_available)
      if has_monster?
        self.checked_for_monsters = true
        self.monsters_abounding = []
        random_monster = nil

        # get random non-boss monster
        loop do
          random_monster = monsters_available[rand(0..monsters_available.length-1)]
          unless random_monster.is_boss
            break
          end
        end

        monsters_abounding.push(random_monster)
      else
        return nil
      end
    end
  end
end
