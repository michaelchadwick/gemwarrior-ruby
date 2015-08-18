# lib/gemwarrior/entities/items/cow.rb
# Item::Cow

require_relative '../item'

module Gemwarrior
  class Cow < Item
    def initialize
      super

      self.name         = 'cow'
      self.description  = 'Grazing on some fake grass, unperturbed, this black and white herd animal looks bored.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.equippable   = false
      self.talkable     = true
    end

    def use(player = nil)
      puts '>> "Moo."'
      { type: nil, data: nil }
    end
  end
end
