# lib/gemwarrior/entities/people/goat.rb
# Entity::Creature::Goat

require_relative '../creature'

module Gemwarrior
  class Goat < Creature
    def initialize
      super

      self.name         = 'goat'
      self.name_display = 'Goat'
      self.description  = 'The scruff is strong with this one as it chews through what appears to be a recent mystery novel most likely thrown into the pen by a passerby.'
      self.face         = 'busy'
      self.hands        = 'hoofy'
      self.mood         = 'content'
    end

    def use(world)
      puts '>> "Baa."'
      { type: nil, data: nil }
    end
  end
end
