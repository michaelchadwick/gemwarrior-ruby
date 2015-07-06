# lib/gemwarrior/entities/creature.rb
# Creature base class

require_relative 'entity'

module Gemwarrior
  class Creature < Entity
    attr_accessor :face,
                  :hands,
                  :mood,
                  :level,
                  :xp,
                  :hp_cur,
                  :hp_max,
                  :atk_lo,
                  :atk_hi,
                  :defense,
                  :dexterity,
                  :inventory,
                  :rox
  end
end
