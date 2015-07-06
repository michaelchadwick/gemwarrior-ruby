# lib/gemwarrior/entities/items/herb.rb
# Item::Herb

require_relative '../item'

module Gemwarrior
  class Herb < Item
    def initialize
      self.name         = 'herb'
      self.description  = 'Green and leafy, this wild herb looks edible.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end

    def use(_player = nil)
      puts 'You place the herb in your mouth, testing its texture. The mysterious herb is easily chewable, and you are able to swallow it without much effort. Slight tingles travel up and down your spine.'
      puts '>> You regain a few hit points.'
      { type: 'health', data: rand(3..5) }
    end
  end
end
