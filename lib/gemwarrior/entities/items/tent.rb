# lib/gemwarrior/entities/items/tent.rb
# Item::Tent

require_relative '../item'

module Gemwarrior
  class Tent < Item
    def initialize
      super

      self.name           = 'tent'
      self.description    = 'A magical, two-room suite pops up when you flick this otherwise folded piece of canvas just right, perfect for a night\'s rest.'
      self.atk_lo         = nil
      self.atk_hi         = nil
      self.takeable       = true
      self.useable        = true
      self.equippable     = false
      self.number_of_uses = 5
    end

    def use(player = nil)
      { type: 'tent', data: self.number_of_uses }
    end
  end
end
