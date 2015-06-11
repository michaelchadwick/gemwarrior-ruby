# lib/gemwarrior/entities/items/bed.rb
# Item::Bed

require_relative '../item'

module Gemwarrior
  class Bed < Item
    def initialize
      self.name         = 'bed'
      self.description  = 'The place where you sleep when you are not adventuring.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end
    
    def use
      puts 'You unmake the bed, get under the covers, close your eyes, and begin to think about all the things you need to do today. You realize sleep is not one of them and quickly get back up, remake the bed, and get on about your day.'
      puts 'You regain a few hit points.'
      {:type => 'rest', :data => 5}
    end
  end
end
