# lib/gemwarrior/entities/items/ladder.rb
# Item::Ladder

require_relative '../item'

module Gemwarrior
  class Ladder < Item
    def initialize
      self.name         = 'ladder'
      self.description  = 'Rickety and crudely-fashioned, this ladder descends down into the dropoff, hopefully heading towards something...anything.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = false
      self.equippable   = false
      self.equipped     = false
    end
    
    def use(inventory = nil)
      {:type => 'nil', :data => 'nil'}
    end
  end
end
