# lib/gemwarrior/entities/people/shifty_woman.rb
# Entity::Creature::Person::ShiftyWoman

require_relative '../person'

module Gemwarrior
  class ShiftyWoman < Person
    def initialize
      super

      self.name         = 'shifty_woman'
      self.name_display = 'Shifty Woman'
      self.description  = 'Sharply dressed with impeccable style, you still can\'t shake the feeling that this otherwise ordinary woman is up to something. It might be the way she almost impulsively looks back and forth along the town street while rubbing her hands together menacingly.'
    end

    def use(world)
      if self.used
        puts 'Attempting a friendly overture again, the woman turns and looks directly at you. Her brown eyes glint in the sun, almost turning an ochre hue. Her look burns you to the core, causing you to physically recoil a little.'
        puts
        puts 'You step back a few paces and quickly look elsewhere.'
      else
        puts 'The woman averts her eyes from you as you commence with a greeting, giving a little scowl while she is at it.'
        
        self.used = true
      end

      { type: nil, data: nil }
    end
  end
end
