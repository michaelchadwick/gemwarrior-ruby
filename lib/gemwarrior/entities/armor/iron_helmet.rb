# lib/gemwarrior/entities/armor/iron_helmet.rb
# Entity::Item::Armor::IronHelmet

require_relative '../armor'

module Gemwarrior
  class IronHelment < Armor
    def initialize
      super

      self.name         = 'iron_helmet'
      self.name_display = 'Iron Helmet'
      self.description  = 'The noggin is better off when encased in a heavy, yet safe, bowl-shaped carapace made of solid iron.'
      self.defense      = 3
    end
  end
end
