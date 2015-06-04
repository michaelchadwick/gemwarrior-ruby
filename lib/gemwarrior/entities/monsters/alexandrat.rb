# lib/gemwarrior/entities/monsters/alexandrat.rb
# Alexandrat monster

require_relative '../monster'

module Gemwarrior
  class Alexandrat < Monster
    def initialize
      self.name         = 'alexandrat'
      self.description  = 'Tiny, but fierce, color-changing rodent.'
      self.face         = 'ugly'
      self.hands        = 'gnarled'
      self.mood         = 'unsurprisingly unchipper'
      
      self.level        = rand(1..2)
      self.hp_cur       = rand((level * 2)..(level * 3))
      self.hp_max       = hp_cur
      self.atk_lo       = rand(level..(level * 1.5).floor)
      self.atk_hi       = rand((level * 1.5).floor..(level * 2))
      self.defense      = rand(level..(level * 1.5).floor)
      self.dexterity    = rand(1..3)

      self.inventory    = Inventory.new
      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand(level..(level * 2))
      
      self.battlecry    = 'Bitey, bitey!'
    end
  end
end
