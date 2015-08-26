# lib/gemwarrior/entities/people/shifty_woman.rb
# Entity::Creature::Person::ShiftyWoman

require_relative '../person'

module Gemwarrior
  class ShiftyWoman < Person
    # CONSTANTS
    SHOO_TEXT = '** BAMF **'
  
    def initialize
      super

      self.name         = 'shifty_woman'
      self.name_display = 'Shifty Woman'
      self.description  = 'Sharply dressed with impeccable style, you still can\'t shake the feeling that this otherwise ordinary woman is up to something. It might be the way she almost impulsively looks back and forth along the town street while rubbing her hands together menacingly.'
    end

    def use(world)
      if self.used
        puts 'Attempting a friendly overture again, the woman turns and looks directly at you. Her brown eyes glint in the sun, almost turning an ochre hue. Her look burns you to the core, causing you to physically recoil a little.'
        STDIN.getc
        puts 'She then growls in a low voice at you:'
        speak('Have you heard of Emerald, the good-for-nothing wizard that doomed our little world of Jool by absconding with the SparklyThing(tm)?')
        STDIN.getc
        puts 'Before you can even begin to answer she throws up her hands and continues, stealing a look off to the side:'
        speak('My life was fine before that idiot decided he needed MORE power than he already has.')
        STDIN.getc
        puts 'She crosses her arms and looks down, seemingly in thought. One of her hands rolls around, a small flicker of light dancing around it as it moves.'
        STDIN.getc
        speak("If only I had some #{"tanzanite".colorize(:blue)}...I could cook up a spell that would take down ol' Em faster than he could lift a wand!")
        STDIN.getc
        if world.player.inventory.contains_item?('sand_jewel')
          puts 'Her head tilts upward, ever so slightly, and she looks at you, one eyebrow cocked:'
          speak('I can sense you might have what I need. I know you want to get rid of Emerald and take back the SparklyThing(tm) to give to our beloved queen, too.')
          STDIN.getc
          speak('I can help. Just give me that little piece of shiny you somehow came across in your travels, and I\'ll do everything in my power to make our shared goal a reality.')
          print 'Give the shifty woman your Sand Jewel? (y/n) '
          answer = gets.chomp.downcase

          case answer
          when 'y', 'yes'
            world.player.inventory.remove_item('sand_jewel')
            world.shifty_to_jewel = true
            speak('Yes...this will do nicely.')
            STDIN.getc
            speak('Forgive me, but I must take my leave for now. When the time is right, I will return!')
            puts 'And with that, she disappears. No puff of smoke or magical to-do...she is just no more.'
          else
            speak('Bah! Begone, fool!')

            Animation.run(phrase: SHOO_TEXT)
            puts

            puts "An aura of electric light surrounds her as you are physically pushed back a foot or so. You feel instantly, uh, #{WordList.new('adjective').get_random_value}."
          end
        else
          puts 'She grumbles to herself a little before giving you a little "shoo" and recommences looking shifty.'
        end
      else
        puts 'The woman averts her eyes from you as you commence with a greeting, giving a little scowl while she is at it.'

        self.used = true
      end

      { type: nil, data: nil }
    end
  end
end
