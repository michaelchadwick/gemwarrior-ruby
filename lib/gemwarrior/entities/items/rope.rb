# lib/gemwarrior/entities/items/rope.rb
# Entity::Item::Rope

require_relative '../item'

module Gemwarrior
  class Rope < Item
    def initialize
      super

      self.name         = 'rope'
      self.name_display = 'Rope'
      self.description  = 'For some reason, a sturdy rope hangs down from a small opening in the metal tunnel\'s ceiling. It appears to hold your weight when taut.'
    end

    def use(world)
      puts 'You hold on to the rope with both hands and begin to climb upwards towards the small opening in the ceiling.'
      puts

      puts 'After a few minutes you pull yourself up onto a field of pure driven snow. Without warning, the rope and opening in the floor vanish.'
      puts
      
      # stats
      world.player.movements_made += 1

      { type: 'move', data: 'Snow Fields (Southeast)' }
    end
  end
end
