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
  end
end
