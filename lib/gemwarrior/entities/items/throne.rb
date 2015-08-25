# lib/gemwarrior/entities/items/throne.rb
# Entity::Item::Throne

require_relative '../item'

module Gemwarrior
  class Throne < Item
    def initialize
      super

      self.name         = 'throne'
      self.name_display = 'Throne'
      self.description  = 'Made of what appears to be unfulfilled desires and latent, flawed happiness, the well-crafted seat still looks kinda comfy. The wizard Emerald sits in it, glaring at you.'
    end
    
    def use
      puts 'Your words fall on deaf chairs. Emerald continues to stare at you.'
      { type: nil, data: nil }
    end
  end
end
