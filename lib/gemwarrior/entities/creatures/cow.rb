# lib/gemwarrior/entities/creatures/cow.rb
# Entity::Creature::Cow

require_relative '../creature'

module Gemwarrior
  class Cow < Creature
    def initialize
      super

      self.name         = 'cow'
      self.name_display = 'Cow'
      self.description  = 'Grazing on some fake grass, unperturbed, this black and white herd animal looks bored.'
      self.face         = 'blank'
      self.hands        = 'stampy'
      self.mood         = 'reserved'
    end

    def use(player = nil)
      puts '>> "Moo."'
      { type: nil, data: nil }
    end
  end
end
