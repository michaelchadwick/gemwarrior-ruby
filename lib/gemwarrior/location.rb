# lib/gemwarrior/location.rb
# Place in the game

require_relative 'constants'

module Gemwarrior
  class Location
    include Errors
    
    attr_reader :id, :name, :description, :locs_connected, :items
  
    def initialize(id, name, description, locs_connected, danger_level, items, monsters_available)
      @id = id
      @name = name
      @description = description
      @locs_connected = locs_connected
      @danger_level = danger_level
      @items = items
      @monsters_available = monsters_available
      @monsters_abounding = []
    end
    
    def describe
      puts "[[[ #{@name} ]]]"
      puts @description
      list_items
      find_monsters
      list_monsters
    end
    
    def describe_item(item_name)
      @item_names = []
      @items.each do |i|
        @item_names.push(i.name)
      end

      if @item_names.include?(item_name)
        @items.each do |i|
          if i.name.eql?(item_name)
            puts "#{i.description}"
            return
          end
        end
      else
        puts ERROR_ITEM_LOC_INVALID
      end
    end
    
    def list_items
      puts " >> Shiny object(s): #{@items.map(&:name).join(', ')}" if @items.length > 0
    end
    
    def list_monsters
      puts " >> Monster(s) abound: #{@monsters_abounding.map(&:name).join(', ')}" if @monsters_abounding.length > 0
    end
    
    def remove_item_from_location(item_name)
      @items.each do |i|
        if i.name.eql?(item_name)
          @items.delete_at(@items.find_index(item_name).to_i)
        end
      end
    end
    
    def has_monster?
      found = false
      unless @danger_level.eql?(:none)
        max = DANGER_LEVEL[@danger_level]
        trigger_values = 0..max
        actual_value = rand(1..100)
        
        if trigger_values.include?(actual_value)
          found = true
        end
      end
      return found
    end
    
    def find_monsters
      if has_monster?
        @monsters_abounding = []
        return @monsters_abounding.push(@monsters_available[rand(0..@monsters_available.length-1)])
      end
    end
    
    def has_loc_to_the?(direction)
      @locs_connected[direction.to_sym]
    end

  end
end
