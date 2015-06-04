# lib/gemwarrior/entities/monsters/coraliz.rb
# Coraliz monster

require_relative '../monster'

module Gemwarrior
  class Coraliz < Monster
    def initialize
      self.name         = 'coraliz'
      self.description  = 'Small blue lizard that slithers around, nipping at your ankles.'
      self.face         = 'spotted'
      self.hands        = 'slippery'
      self.mood         = 'emotionless'
      
      self.level        = rand(5..8)
      self.hp_cur       = rand((level * 2)..(level*3))
      self.hp_max       = hp_cur
      self.atk_lo       = rand(level..(level * 3).floor)
      self.atk_hi       = rand((level * 3).floor..(level * 3).floor)
      self.defense      = rand(4..6)
      self.dexterity    = rand(7..9)

      self.inventory    = Inventory.new
      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand(level..(level * 3))
      
      self.battlecry    = 'Where am I? You\'ll never guess!'
    end
  end
end
