# lib/gemwarrior/entities/items/tree.rb
# Item::Tree

require_relative '../item'

module Gemwarrior
  class Tree < Item
    def initialize
      self.name         = 'tree'
      self.description  = 'A mighty representation of nature, older than your father\'s father\'s second great-uncle.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = false
      self.equippable   = false
      self.equipped     = false
    end
  end
end
