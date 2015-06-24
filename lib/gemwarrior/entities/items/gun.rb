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
    
    def use(player = nil)
      puts 'You pull the trigger on the gun, but realize there are no bullets in it. So, it does not do much except cause a barely audible *click* sound.'
      {:type => nil, :data => nil}
    end
  end
end
