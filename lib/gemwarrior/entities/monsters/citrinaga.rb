# lib/gemwarrior/entities/monsters/citrinaga.rb
# Citrinaga monster

require_relative '../monster'

module Gemwarrior
  class Citrinaga < Monster
    def initialize
      super

      self.name         = 'citrinaga'
      self.description  = 'Refreshing in its shiny, gleaming effectiveness at ending your life.'
      self.face         = 'shiny'
      self.hands        = 'glistening'
      self.mood         = 'staid'

      self.level        = rand(5..7)
      self.hp_cur       = rand((level * 2)..(level*3))
      self.hp_max       = hp_cur
      self.atk_lo       = rand(level..(level*1.5).floor)
      self.atk_hi       = rand((level*1.5).floor..(level*3).floor)
      self.defense      = rand(7..9)
      self.dexterity    = rand(6..7)

      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand(level..(level * 3))

      self.battlecry    = 'Slice and dice so nice!'
    end
  end
end
