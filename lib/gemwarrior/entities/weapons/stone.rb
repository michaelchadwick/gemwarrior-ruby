# lib/gemwarrior/entities/weapons/stone.rb
# Entity::Item::Weapon::Stone

require_relative '../weapon'

module Gemwarrior
  class Stone < Weapon
    def initialize
      super

      self.name         = 'stone'
      self.name_display = 'Stone'
      self.description  = 'A small, yet quite sharp, sedimentary pebble, suitable for tossing in amusement, and perhaps combat.'
      self.atk_lo       = 1
      self.atk_hi       = 2
    end
    
    def use(world)
      puts 'You toss the stone a few feet into the air, and then it falls back into your palm. The experience was truly thrilling.'
      { type: nil, data: nil }
    end
  end
end
