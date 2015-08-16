# lib/gemwarrior/entities/items/bed.rb
# Item::Bed

require_relative '../item'

module Gemwarrior
  class Bed < Item
    # CONSTANTS
    USE_TEXT = '** ZZZZZ **'

    def initialize
      super

      self.name         = 'bed'
      self.description  = 'The place where you sleep when you are not adventuring.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
    end

    def use(player = nil)
      if player.at_full_hp?
        puts 'You feel perfectly healthy and decide not to actually use the bed. Besides, the trail of fire ants currently leading up to and around the furniture seem somehow uninviting.'
        { type: nil, data: nil }
      else
        Animation::run(phrase: USE_TEXT)
        puts 'You unmake the bed, get under the covers, close your eyes, and begin to think about all the things you need to do today. You realize sleep is not one of them and quickly get back up, remake the bed, and get on about your day.'
        puts '>> You regain a few hit points.'
        { type: 'rest', data: 5 }
      end
    end
  end
end
