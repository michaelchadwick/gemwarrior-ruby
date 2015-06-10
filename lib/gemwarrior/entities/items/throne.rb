# lib/gemwarrior/entities/items/throne.rb
# Item::Throne

require_relative '../item'

module Gemwarrior
  class Throne < Item
    def initialize
      self.name         = 'throne'
      self.description  = 'Made of what appears to be unfulfilled desires and latent, flawed happiness, the well-crafted seat still looks kinda comfy.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = false
      self.equippable   = false
      self.equipped     = false
    end
  end
end
