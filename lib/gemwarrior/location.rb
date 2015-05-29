# lib/gemwarrior/location.rb
# Place in the game

require 'matrext'

module Gemwarrior
  class Location
    # CONSTANTS
    ## HASHES
    DANGER_LEVEL = {:none => 0, :low => 15, :moderate => 30, :high => 55, :assured => 100}
    
    ## ERRORS
    ERROR_LOCATION_ITEM_REMOVE_INVALID   = 'That item cannot be removed as it doesn\'t exist here.'
    ERROR_LOCATION_DESCRIBE_ENTITY_INVALID = 'You don\'t see that here.'

    attr_accessor :id, :name, :description, :locs_connected, :danger_level, 
                  :items, :monsters_available, :monsters_abounding, :checked_for_monsters
  
    def initialize(id, name, description, locs_connected, danger_level, items, monsters_available)
      self.id = id
      self.name = name
      self.description = description
      self.locs_connected = locs_connected
      self.danger_level = danger_level
      self.items = items
      self.monsters_available = monsters_available
      self.monsters_abounding = []
      self.checked_for_monsters = false
    end
    
    def status
      status_text =  name.ljust(20).upcase
      status_text << "#{description}\n"
      status_text.to_s
    end
    
    def describe
      desc_text = ""
      desc_text << "[ #{name} ]\n"
      desc_text << description
      unless checked_for_monsters?
        populate_monsters
      end
      unless list_items.nil?
        desc_text << list_items
      end
      unless list_monsters.nil?
        desc_text << list_monsters
      end
      desc_text << list_paths

      return desc_text
    end
    
    def describe_entity(entity_name)
      if items.map(&:name).include?(entity_name)
        items.each do |i|
          if i.name.eql?(entity_name)
            return "#{i.description}"
          end
        end
      elsif
        if monsters_abounding.map(&:name).include?(entity_name)
          monsters_abounding.each do |m|
            if m.name.eql?(entity_name)
              return "#{m.description}"
            end
          end
        end
      else
        ERROR_LOCATION_DESCRIBE_ENTITY_INVALID
      end
    end
    
    def remove_item(item_name)
      if items.map(&:name).include?(item_name)
        items.reject! { |item| item.name == item_name }
      else
        ERROR_LOCATION_ITEM_REMOVE_INVALID
      end
    end

    def remove_monster(name)
      if has_monster_to_attack?(name)
        monsters_abounding.reject! { |monster| monster.name == name }
      end
    end
    
    def has_loc_to_the?(direction)
      locs_connected[direction.to_sym]
    end

    def has_monster_to_attack?(name)
      monsters_abounding.map(&:name).include?(name.downcase)
    end
    
    def monster_by_name(name)
      monsters_abounding.each do |m|
        if m.name.eql?(name)
          return m
        end
      end
    end
    
    private
    
    def checked_for_monsters?
      checked_for_monsters
    end
    
    def list_items
      return "\n >> Shiny object(s): #{items.map(&:name).join(', ')}" if items.length > 0
    end
    
    def list_monsters
      return "\n >> Monster(s) abound: #{monsters_abounding.map(&:name).join(', ')}" if monsters_abounding.length > 0
    end
    
    def list_paths
      valid_paths = []
      locs_connected.each do |key, value|
        unless value.nil?
          valid_paths.push(key.to_s)
        end
      end
      return "\n >> Paths: #{valid_paths.join(', ')}"
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
  
    def populate_monsters
      self.checked_for_monsters = true
      if has_monster?
        self.monsters_abounding = []
        return monsters_abounding.push(monsters_available[rand(0..monsters_available.length-1)])
      else
        return nil
      end
    end
  end
end
