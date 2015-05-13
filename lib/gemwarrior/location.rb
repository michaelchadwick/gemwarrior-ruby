# lib/gemwarrior/location.rb
# Place in the game

module Gemwarrior
  class Location
    attr_reader :id, :name
  
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

  end
end