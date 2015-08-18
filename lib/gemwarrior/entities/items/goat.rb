# lib/gemwarrior/entities/items/goat.rb
# Item::Goat

require_relative '../item'

module Gemwarrior
  class Goat < Item
    def initialize
      super

      self.name         = 'goat'
      self.description  = 'The scruff is strong with this one as it chews through what appears to be a recent mystery novel most likely thrown into the pen by a passerby.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.equippable   = false
      self.talkable     = true
    end

    def use(player = nil)
      puts '>> "Baa."'
      { type: nil, data: nil }
    end
  end
end
