# lib/gemwarrior/entities/items/bullet.rb
# Entity::Item::Bullet

require_relative '../item'

module Gemwarrior
  class Bullet < Item
    # CONSTANTS
    USE_TEXT = '** ZZZZZ **'

    def initialize
      super

      self.name         = 'bullet'
      self.name_display = 'Bullet'
      self.description  = 'Gunpowder packed into a small metallic tube, ready to be fired from...something.'
      self.takeable     = true
    end

    def use(world)
      puts 'You could throw this at a monster, but somehow the force of it would be less than desired.'
      { type: nil, data: nil }
    end
  end
end
