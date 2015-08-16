# lib/gemwarrior/entities/items/opalaser.rb
# Item::Opalaser

require_relative '../item'

module Gemwarrior
  class Opalaser < Item
    def initialize
      super

      self.name         = 'opalaser'
      self.description  = 'Gleaming with supernatural light, this object feels alien, yet familiar.'
      self.atk_lo       = 9
      self.atk_hi       = 11
      self.takeable     = true
      self.useable      = true
      self.equippable   = true
    end

    def use(player = nil)
      puts 'You pull the "trigger" on the opalaser, but nothing happens.'
      { type: nil, data: nil }
    end
  end
end
