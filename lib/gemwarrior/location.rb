# lib/gemwarrior/location.rb
# Place in the game

module Gemwarrior
  class Location
    attr_reader :id, :name, :locToNorth, :locToEast, :locToSouth, :locToWest
  
    def initialize(id, name, description, locToNorth = nil, locToEast = nil, locToSouth = nil, locToWest = nil)
      @id = id
      @name = name
      @description = description
      @locToNorth = locToNorth
      @locToEast = locToEast
      @locToSouth = locToSouth
      @locToWest = locToWest
      @monsters = []
      @items = []
    end
    
    def describe
      puts "/[#{@name}]\\"
      puts @description
    end
    
    def is_valid?(locations, loc_id)
      is_valid = false
      locations.each do |loc|
        if loc.id.equal? loc_id
          is_valid = true
        end
      end
      return is_valid
    end

  end
end