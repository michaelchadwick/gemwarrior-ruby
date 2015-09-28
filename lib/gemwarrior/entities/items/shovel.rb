# lib/gemwarrior/entities/items/shovel.rb
# Entity::Item::Shovel

require_relative '../item'

module Gemwarrior
  class Shovel < Item
    # CONSTANTS
    DIG_NOISE = '*DIG*'
  
    def initialize
      super

      self.name         = 'shovel'
      self.name_display = 'Shovel'
      self.description  = 'You can really "dig" this tool, despite its well-worn appearance.'
    end

    def use(world)
      cur_location = world.location_by_coords(world.player.cur_coords)

      if cur_location.name.eql?('pain_quarry-west') and cur_location.contains_item?('locker_corner')
        puts 'You bolster yourself and then begin the tedious job of digging the locker out of its several-inch-deep prison of sand with your trusty shovel.'
        puts

        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)

        puts
        puts 'You drop the head of the shovel into the ground, lean on it for a moment, and wipe the sweat from your brow. This quarry is really causing you considerable pain.'
        STDIN.getc

        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)
        Animation.run(phrase: DIG_NOISE)

        puts
        puts 'After what feels like several hours, you finally unearth the locker from the ground, open it, and place it next to its previous location.'
        
        cur_location.add_item('locker')
        cur_location.remove_item('locker_corner')
        
        { type: 'dmg', data: rand(1..2) }
      else
        puts 'You grip the shovel by its handle and thrust it, head-first, into the sky. Huzzah!'

        { type: nil, data: nil }
      end
    end
  end
end
