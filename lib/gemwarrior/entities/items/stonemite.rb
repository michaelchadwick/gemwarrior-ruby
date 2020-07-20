# lib/gemwarrior/entities/items/stonemite.rb
# Entity::Item::Stonemite

require_relative '../item'

module Gemwarrior
  class Stonemite < Item
    def initialize
      super

      self.name         = 'stonemite'
      self.name_display = 'Stonemite'
      self.description  = 'Stubby cave debris that is neat to look at, as it is off-grey and sparkly, but the size makes it unusable as anything but skipping on a lake.'
      self.takeable     = true
    end

    def use(world)
      puts 'You turn the stonemite over and over in your hand. It continues to be a small rock of little import.'
      { type: nil, data: nil }
    end
  end
end
