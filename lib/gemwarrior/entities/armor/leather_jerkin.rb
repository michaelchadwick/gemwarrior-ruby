# lib/gemwarrior/entities/armor/leather_jerkin.rb
# Entity::Item::Armor::LeatherJerkin

require_relative '../armor'

module Gemwarrior
  class LeatherJerkin < Armor
    def initialize
      super

      self.name         = 'leather_jerkin'
      self.name_display = 'Leather Jerkin'
      self.description  = 'Brownish-black in color and fairly form-fitting, this jerkin will soften any blow a bit, at least.'
      self.defense      = 2
    end
  end
end
