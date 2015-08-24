# lib/gemwarrior/entities/monsters/amberoo.rb
# Entity::Creature::Monster::Amberoo

require_relative '../monster'

module Gemwarrior
  class Amberoo < Monster
    def initialize
      super

      self.name         = 'amberoo'
      self.name_display = 'Amberoo'
      self.description  = 'Fossilized and jumping around like an adorably dangerous threat from the past.'
      self.battlecry    = 'I\'m hoppin\' mad!'
      self.face         = 'punchy'
      self.hands        = 'balled'
      self.mood         = 'jumpy'

      self.level        = rand(1..2)
      self.hp_cur       = rand((level * 2)..(level * 3))
      self.hp_max       = hp_cur
      self.atk_lo       = rand(level..(level * 2))
      self.atk_hi       = rand((level * 2)..(level * 2.5).floor)
      self.defense      = rand((level * 2)..(level * 2.5).floor)
      self.dexterity    = rand(3..4)

      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand(level..(level * 2))
    end
  end
end
