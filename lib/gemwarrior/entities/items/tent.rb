# lib/gemwarrior/entities/items/tent.rb
# Item::Tent

require_relative '../item'

module Gemwarrior
  class Tent < Item
    def initialize
      self.name         = 'tent'
      self.description  = 'A magical, two-room suite pops up when you flick this otherwise folded piece of canvas just right, perfect for a night\'s rest.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end

    def use(_player = nil)
      { type: 'action', data: 'rest' }
    end
  end
end
