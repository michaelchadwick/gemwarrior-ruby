# lib/gemwarrior/entities/items/gun.rb
# Item::Gun

require_relative '../item'

module Gemwarrior
  class Gun < Item
    def initialize
      self.name         = 'gun'
      self.description  = 'Pew pew goes this firearm, you suspect.'
      self.atk_lo       = 2
      self.atk_hi       = 4
      self.takeable     = true
      self.useable      = true
      self.equippable   = true
      self.equipped     = false
    end

    def use(player = nil)
      puts 'You pull the trigger on the gun, but it does not fire. An inscription on the barrel reads: "Only shoots when pointed at a monster." How safe!'
      { type: nil, data: nil }
    end
  end
end
