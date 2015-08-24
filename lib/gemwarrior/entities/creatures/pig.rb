# lib/gemwarrior/entities/people/pig.rb
# Entity::Creature::Pig

require_relative '../creature'

module Gemwarrior
  class Pig < Creature
    def initialize
      super

      self.name         = 'pig'
      self.name_display = 'Pig'
      self.description  = 'Dirty, eating slop, but still kind of cute. Yep, this is a pig.'
      self.face         = 'messy'
      self.hands        = 'muddy'
      self.mood         = 'restless'
    end

    def use(player = nil)
      puts '>> "Oink."'
      { type: nil, data: nil }
    end
  end
end
