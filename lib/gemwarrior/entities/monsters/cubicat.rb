# lib/gemwarrior/entities/monsters/cubicat.rb
# Cubicat monster

require_relative '../monster'

module Gemwarrior
  class Cubicat < Monster
    def initialize
      super

      self.name         = 'cubicat'
      self.description  = 'Perfectly geometrically cubed feline, fresh from its woven enclosure, claws at the ready.'
      self.face         = 'striking'
      self.hands        = 'grippy'
      self.mood         = 'salacious'

      self.level        = rand(6..8)
      self.hp_cur       = rand((level * 2)..(level * 3))
      self.hp_max       = hp_cur
      self.atk_lo       = rand(level..(level * 2).floor)
      self.atk_hi       = rand((level * 2).floor..(level * 3).floor)
      self.defense      = rand(5..7)
      self.dexterity    = rand(8..10)

      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand(level..(level * 2))

      self.battlecry    = 'I don\'t really care, as long as you die!'
    end
  end
end
