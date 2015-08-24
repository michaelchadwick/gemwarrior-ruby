# lib/gemwarrior/entities/person.rb
# Entity::Creature::Person base class

require_relative 'creature'

module Gemwarrior
  class Person < Creature
    def use(player = nil)
      'That person does not seem to want to talk to you right now.'
    end
  end
end
