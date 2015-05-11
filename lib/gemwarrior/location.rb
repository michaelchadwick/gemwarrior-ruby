# lib/location.rb

module Gemwarrior
  class Location
    def initialize(locationID, short_desc, long_desc)
      @locationID = locationID
      @short_desc = short_desc
      @long_desc = long_desc
    end
    
    def describe
      puts @short_desc
      puts @long_desc
    end
  end
end