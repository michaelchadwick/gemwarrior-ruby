# lib/gemwarrior/entities/items/arena_door.rb
# Entity::Item::ArenaDoor

require_relative '../item'

module Gemwarrior
  class ArenaDoor < Item
    def initialize
      super

      self.name         = 'arena_door'
      self.name_display = 'Arena Door'
      self.description  = 'The Arena is massive, with its numerous columns and stone walls stretching to the sky, but its entrance door is no slouch, keeping apace. Made of reinforced granite and impossible to break down, it nevertheless opens for you while battles are in session.'
    end
  end
end
