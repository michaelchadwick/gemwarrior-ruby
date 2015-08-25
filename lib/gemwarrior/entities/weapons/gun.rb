# lib/gemwarrior/entities/weapons/gun.rb
# Entity::Item::Weapon::Gun

require_relative '../weapon'

module Gemwarrior
  class Gun < Weapon
    def initialize
      super

      self.name         = 'gun'
      self.name_display = 'Gun'
      self.description  = 'Pew pew goes this firearm, you suspect (if it has bullets).'
      self.atk_lo       = 2
      self.atk_hi       = 6
    end

    def use(world)
      puts 'You pull the trigger on the gun, but it does not fire. An inscription on the barrel reads: "Only shoots when pointed at a monster." How safe!'
      { type: nil, data: nil }
    end
  end
end
