# lib/gemwarrior/entities/creature.rb
# Creature base class

require_relative 'entity'
require_relative '../inventory'

module Gemwarrior
  class Creature < Entity
    attr_accessor :id, :name, :description, :face, :hands, :mood, 
                  :level, :hp_cur, :hp_max, :inventory
    
    def initialize(options)
      self.id           = options[:id]
      self.name         = options[:name]
      self.description  = options[:description]
      self.face         = options[:face]
      self.hands        = options[:hands]
      self.mood         = options[:mood]

      self.level        = options[:level]
      self.hp_cur       = options[:hp_cur]
      self.hp_max       = options[:hp_max]

      self.inventory    = options[:inventory]
    end
  end
end
