# lib/gemwarrior/location.rb
# Place in the game

module Gemwarrior
  class Location
  
    @id = nil
    @name = 'Location'
    @description = 'A place, formless, nameless.'
    @locToNorth = nil
    @locToEast = nil
    @locToSouth = nil
    @locToWest = nil
    @monsters = []
    @items = []
  
    attr_reader :id, :name
  
    def initialize(id, name, description)
      @id = id
      @name = name
      @description = description
    end
    
    def describe
      puts "/[#{@name}]\\"
      puts @description
    end

  end
end