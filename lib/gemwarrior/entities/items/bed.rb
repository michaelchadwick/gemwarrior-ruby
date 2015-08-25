# lib/gemwarrior/entities/items/bed.rb
# Entity::Item::Bed

require_relative '../item'

module Gemwarrior
  class Bed < Item
    # CONSTANTS
    USE_TEXT = '** ZZZZZ **'

    def initialize
      super

      self.name         = 'bed'
      self.name_display = 'Bed'
      self.description  = 'The place where you sleep when you are not adventuring.'
    end

    def use(world)
      if world.player.at_full_hp?
        puts 'You feel perfectly healthy and decide not to actually use the bed. Besides, the trail of fire ants currently leading up to and around the furniture seem somehow uninviting.'
        { type: nil, data: nil }
      else
        Animation.run(phrase: USE_TEXT)
        puts 'You unmake the bed, get under the covers, close your eyes, and begin to think about all the things you need to do today. You realize sleep is not one of them and quickly get back up, remake the bed, and get on about your day.'
        puts '>> You regain a few hit points.'.colorize(:green)
        { type: 'rest', data: rand(5..7) }
      end
    end
  end
end
