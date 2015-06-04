# lib/gemwarrior/entities/monsters/amethystle.rb
# Amethystle monster

require_relative '../monster'

module Gemwarrior
  class Amethystle < Monster
    def initialize
      self.name         = 'amethystle'
      self.description  = 'Sober and contemplative, it moves with purplish tentacles swaying in the breeze.'
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

      self.inventory    = Inventory.new
      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand(level..(level * 2))
      
      self.battlecry    = 'You\'ve found yourself in quite the thorny issue!'
    end
  end
end
