# lib/gemwarrior/entities/items/tree.rb
# Entity::Item::Tree

require_relative '../item'

module Gemwarrior
  class Tree < Item
    def initialize
      super

      self.name         = 'tree'
      self.name_display = 'Tree'
      self.description  = 'A mighty representation of nature, older than your father\'s father\'s second great-uncle.'
    end
  end
end
