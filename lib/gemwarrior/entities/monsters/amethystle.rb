# lib/gemwarrior/entities/monsters/amethystle.rb
# Entity::Creature::Monster::Amethystle

require_relative '../monster'

module Gemwarrior
  class Amethystle < Monster
    def initialize
      super

      self.name         = 'amethystle'
      self.name_display = 'Amethystle'
      self.description  = 'Sober and contemplative, it moves with purplish tentacles swaying in the breeze.'
      self.battlecry    = 'You\'ve found yourself in quite the thorny issue!'
      self.face         = 'sharp'
      self.hands        = 'loose'
      self.mood         = 'mesmerizing'

      self.level        = rand(2..3)
      self.hp_cur       = rand((level * 2)..(level * 3))
      self.hp_max       = hp_cur
      self.atk_lo       = rand(level..(level * 1.5).floor)
      self.atk_hi       = rand((level * 1.5).floor..(level * 2.5).floor)
      self.defense      = rand(2..4)
      self.dexterity    = rand(1..2)

      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand(level..(level * 2))
    end
  end
end
