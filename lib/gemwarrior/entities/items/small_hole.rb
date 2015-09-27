# lib/gemwarrior/entities/items/small_hole.rb
# Entity::Item::SmallHole

require_relative '../person'

module Gemwarrior
  class SmallHole < Item
    def initialize
      super

      self.name         = 'small_hole'
      self.name_display = 'Small Hole'
      self.description  = 'Amongst the rubble of the alcove, a small hole, barely big enough for a rodent, exists in an absently-minded way near the bottom of the wall.'
    end

    def use(world)
      if !self.used
        self.used = true

        Audio.play_synth(:uncover_secret)
        puts 'You lower yourself to the ground and attempt to peer in the hole in the wall. Just as you begin to think this is a fruitless endeavor, a pair of bright, beady eyes manifest, and an unexpectedly low voice speaks:'
        Person.new.speak('Hello. I\'m Rockney, of Rockney\'s Hole in the Wall. Pleasure!')

        tunnel_alcove = world.location_by_name('tunnel_alcove')
        tunnel_alcove.items.push(Rockney.new)
        puts world.describe(tunnel_alcove)
      else
        puts 'Rockney appears to still be in the small hole, patiently waiting for you.'
      end

      { type: nil, data: nil }
    end
  end
end
