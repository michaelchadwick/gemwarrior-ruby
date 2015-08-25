# lib/gemwarrior/entities/weapons/opalaser.rb
# Entity::Item::Weapon::Opalaser

require_relative '../item'

module Gemwarrior
  class Opalaser < Weapon
    def initialize
      super

      self.name         = 'opalaser'
      self.name_display = 'Opalaser'
      self.description  = 'Gleaming with supernatural light, this object feels alien, yet familiar.'
      self.atk_lo       = 9
      self.atk_hi       = 11
    end

    def use(world)
      puts 'You pull the "trigger" on the opalaser, but nothing happens.'
      { type: nil, data: nil }
    end
  end
end
