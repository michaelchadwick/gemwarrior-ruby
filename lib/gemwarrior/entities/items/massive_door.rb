# lib/gemwarrior/entities/items/massive_door.rb
# Item::MassiveDoor

require_relative '../item'

module Gemwarrior
  class MassiveDoor < Item
    def initialize
      self.name         = 'massive door'
      self.description  = 'Translucent, but not transparent, this door constructed of condensed water vapor is like nothing you have ever seen.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = false
      self.equippable   = false
      self.equipped     = false
    end
  end
end
