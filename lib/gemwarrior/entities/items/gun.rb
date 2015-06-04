# lib/gemwarrior/entities/items/gun.rb
# Item::Gun

require_relative '../item'

module Gemwarrior
  class Gun < Item
    def initialize
      self.name         = 'gun'
      self.description  = 'Pew pew goes this firearm, you suspect.'
      self.atk_lo       = 3
      self.atk_hi       = 5
      self.takeable     = true
      self.useable      = true
      self.equippable   = true
      self.equipped     = false
    end
  end
end
