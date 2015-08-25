# lib/gemwarrior/entities/person.rb
# Entity::Creature::Person base class

require_relative 'creature'

module Gemwarrior
  class Person < Creature
    def initialize
      super
      
      self.name         = 'person.'
      self.name_display = Formatting::upstyle(name)
      self.description  = 'It appears to be a person of some kind.'
    end
  
    def use(world)
      'That person does not seem to want to talk to you right now.'
    end
  end
end
