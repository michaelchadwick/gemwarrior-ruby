# lib/gemwarrior/entities/monsters/aquamarine.rb
# Aquamarine monster

require_relative '../monster'

module Gemwarrior
  class Aquamarine < Monster
    def initialize
      super
    
      self.name         = 'aquamarine'
      self.description  = 'It is but one of the few, the proud, the underwater.'
      self.face         = 'strained'
      self.hands        = 'hairy'
      self.mood         = 'tempered'
      
      self.level        = rand(3..4)
      self.hp_cur       = rand((level * 2)..(level * 3))
      self.hp_max       = hp_cur
      self.atk_lo       = rand(level..(level * 1.5).floor)
      self.atk_hi       = rand((level * 1.5).floor..(level * 2.5).floor)
      self.defense      = rand(3..5)
      self.dexterity    = rand(4..6)

      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand(level..(level * 2))
      
      self.battlecry    = 'Attention! You are about to get smashed!'
    end
  end
end
