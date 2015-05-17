# lib/gemwarrior/location.rb
# Place in the game

require_relative 'constants'

module Gemwarrior
  class Location
    include Errors
    
    attr_reader :id, :name, :description, :locs_connected, :items
  
    def initialize(id, name, description, locs_connected, items)
      @id = id
      @name = name
      @description = description
      @locs_connected = locs_connected
      @items = items
      @monsters = []
    end
    
    def describe
      puts "[[[ #{@name} ]]]"
      puts @description
      list_items
    end
    
    def describe_item(item_name)
      @item_names = []
      @items.each do |i|
        @item_names.push(i.name)
      end

      if @item_names.include?(item_name)
        item_found = false
        @items.each do |i|
          if i.name.eql?(item_name)
            puts "#{i.description}"
            item_found = true
            return
          end
        end
      else
        puts ERROR_ITEM_INVALID
      end
    end
    
    def list_items
      loc_items = []
      @items.each do |i|
        loc_items.push(i.name)
      end
      puts ">> Shiny object(s): #{loc_items.join(', ')}"
    end
    
    def has_loc_to_the?(direction)
      @locs_connected[direction.to_sym]
    end

  end
end
