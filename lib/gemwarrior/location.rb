# lib/gemwarrior/location.rb
# Place in the game

require 'pry'

module Gemwarrior
  class Location
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
      puts "/[#{@name}]\\"
      puts @description
      list_items
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