# lib/gemwarrior/entities/items/pig.rb
# Item::Pig

require_relative '../item'

module Gemwarrior
  class Pig < Item
    def initialize
      super

      self.name         = 'pig'
      self.description  = 'Dirty, eating slop, but still kind of cute. Yep, this is a pig.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.equippable   = false
      self.talkable     = true
    end

    def use(player = nil)
      puts '>> "Oink."'
      { type: nil, data: nil }
    end
  end
end
