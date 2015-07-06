# lib/gemwarrior/entities/items/opalaser.rb
# Item::Opalaser

require_relative '../item'

module Gemwarrior
  class Opalaser < Item
    def initialize
      self.name         = 'opalaser'
      self.description  = 'Gleaming with supernatural light, this object feels alien, yet familiar.'
      self.atk_lo       = 10
      self.atk_hi       = 12
      self.takeable     = true
      self.useable      = true
      self.equippable   = true
      self.equipped     = false
    end

    def use(_player = nil)
      puts 'You pull the "trigger" on the opalaser, but nothing happens.'
      { type: nil, data: nil }
    end
  end
end
