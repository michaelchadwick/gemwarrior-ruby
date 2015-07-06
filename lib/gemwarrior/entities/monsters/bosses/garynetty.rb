# lib/gemwarrior/entities/monsters/garynetty.rb
# Garrynetty monster

require_relative '../../monster'

module Gemwarrior
  class Garynetty < Monster
    def initialize
      self.name         = 'Garynetty'
      self.description  = 'Conservative, yet odd, the Garynetty is not messing around.'
      self.face         = 'irregular'
      self.hands        = 'sharp'
      self.mood         = 'abrasive'

      self.level        = rand(12..15)
      self.hp_cur       = rand((level * 2.5).floor..(level * 3.5).floor)
      self.hp_max       = hp_cur
      self.atk_lo       = rand((level * 2)..(level * 2.5).floor)
      self.atk_hi       = rand((level * 2.5).floor..(level * 3).floor)
      self.defense      = rand(7..9)
      self.dexterity    = rand(10..12)

      self.inventory    = Inventory.new
      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand((level * 3)..(level * 4))

      self.battlecry    = '...?!'
      self.is_boss      = true
    end
  end
end
