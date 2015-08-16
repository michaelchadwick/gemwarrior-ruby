# lib/gemwarrior/entities/items/stonemite.rb
# Item::Stonemite

require_relative '../item'

module Gemwarrior
  class Stonemite < Item
    def initialize
      super

      self.name         = 'stonemite'
      self.description  = 'Stubby cave debris that is neat to look at, as it is off-grey and sparkly, but the size makes it unusable as anything but skipping on a lake.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = false
      self.equippable   = false
      self.equipped     = false
    end
  end
end
