# lib/gemwarrior/entities/items/pond.rb
# Item::Pond

require_relative '../item'

module Gemwarrior
  class Pond < Item
    # CONTACTS
    NEEDED_ITEMS = ['dehumidifier', 'feather', 'gun', 'stalactite']

    def initialize
      self.name         = 'pond'
      self.description  = 'This tiny pool of water self-ripples every minute or so. Small, floating insects buzz around merrily. A small plaque lays at the foot, reading: "If the right objects curious doth possess, touch the water\'s surface and you\'ll get redress."'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end

    def use(player = nil)
      puts 'You gently place your fingers on the pond\'s rippling surface.'

      if (NEEDED_ITEMS - player.inventory.items.map(&:name)).empty?
        puts 'The pond water explodes with a force that knocks you back onto the ground. When you come to, you notice the depression in the ground where the pond once was now has a new curious object!'
        self.description = 'A barren depression in the ground is all that is left of the pond.'
        return { type: 'item', data: 'Opalaser' }
      else
        puts 'You graze your fingers within the pond for a moment, feeling the coolness. You feel zen.'
        return { type: nil, data: nil }
      end
    end
  end
end
