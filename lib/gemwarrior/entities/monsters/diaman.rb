# lib/gemwarrior/entities/monsters/diaman.rb
# Entity::Creature::Monster::Diaman

require_relative '../monster'

module Gemwarrior
  class Diaman < Monster
    def initialize
      super

      self.name         = 'diaman'
      self.name_display = 'Diaman'
      self.description  = 'Crystalline structure in the form of a man, lumbering toward you, with outstretched, edged pincers.'
      self.battlecry    = 'Precious human, prepare to be lost to the annals of time!'
      self.face         = 'bright'
      self.hands        = 'jagged'
      self.mood         = 'adamant'

      self.level        = rand(8..10)
      self.hp_cur       = rand((level * 2)..(level * 3))
      self.hp_max       = hp_cur
      self.atk_lo       = rand(level..(level * 2.5).floor)
      self.atk_hi       = rand((level * 2.5).floor..(level * 3).floor)
      self.defense      = rand(5..7)
      self.dexterity    = rand(8..10)

      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand(level..(level * 2))
    end
  end
end
