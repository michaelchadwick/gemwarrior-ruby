# lib/gemwarrior/entities/items/locker_corner.rb
# Entity::Item::LockerCorner

require_relative '../item'

module Gemwarrior
  class LockerCorner < Item
    attr_accessor :locked

    def initialize
      super

      self.name         = 'locker_corner'
      self.name_display = 'Locker (Corner)'
      self.description  = 'The top corner of what appears to be a small locker is slightly sticking up from the sand floor.'
      self.takeable     = false
      self.useable      = true
    end

    def use(world)
      puts 'Pulling with all your might on the corner of the locker doesn\'t get it it budge one inch. Some other method is going to be needed.'

      { type: nil, data: nil }
    end
  end
end
