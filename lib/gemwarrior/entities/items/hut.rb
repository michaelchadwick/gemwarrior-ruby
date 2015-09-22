# lib/gemwarrior/entities/items/hut.rb
# Entity::Item::Hut

require_relative '../item'

module Gemwarrior
  class Hut < Item
    def initialize
      super

      self.name         = 'hut'
      self.name_display = 'Hut'
      self.description  = 'A simple thatched hut, sitting in the middle of the plains. Nothing about it seems odd, except its existence among the otherwise featureless landscape.'
    end

    def use(world)
      puts 'You peer inside, but it is completely vacant at the moment, leaving you marginally disappointed.'

      { type: nil, data: nil }
    end
  end
end
