# lib/gemwarrior/entities/monsters/bosses/emerald.rb
# Entity::Creature::Monster::Emerald (BOSS)

require_relative '../../monster'
require_relative '../../items/sparkly_thing'

module Gemwarrior
  class Emerald < Monster
    # CONSTANTS
    MOVE_TEXT = '** WHOOOOOOSH **'

    def initialize
      super

      self.name           = 'emerald'
      self.name_display   = 'Emerald'
      self.description    = 'A wily, beefy, tower of a man, Emerald looks to be a champion of both wisdom, from what you\'ve heard, AND strength, from what you plainly see. He sports a constant glint in his eyes as he faces you, dead-on.'
      self.battlecry      = 'You\'ve come for the SparklyThing(tm), I see. To that I say: Ha ha ha ha ha! Prepare yourself fool: today your whole life crumbles!'
      self.face           = 'gleaming'
      self.hands          = 'tantalizing'
      self.mood           = 'enraged'

      self.level          = 15
      self.hp_cur         = rand((level * 3)..(level * 4))
      self.hp_max         = hp_cur
      self.atk_lo         = rand(level..(level * 2.5).floor)
      self.atk_hi         = rand((level * 2.5).floor..(level * 3).floor)
      self.defense        = rand(5..7)
      self.dexterity      = rand(8..10)

      self.inventory      = Inventory.new(items = [SparklyThing.new])
      self.rox            = rand((level * 9)..(level * 11))
      self.xp             = rand((level * 13)..(level * 15))

      self.is_boss        = true
    end
    
    def initiate_ending(world)
      # fanfare!
      Audio.play_synth(:win_game)

      # get reference to throne room, emerald monster, and throne item
      throne_room = world.location_by_coords(world.location_coords_by_name('Sky Tower (Throne Room)'))
      emerald = throne_room.bosses_abounding[0]
      throne = throne_room.items.each { |i| i.name == 'throne' }[0]

      # emerald is dead, so room and items change
      emerald.is_dead                 = true
      emerald.face                    = 'sullen'
      emerald.hands                   = 'limp'
      emerald.mood                    = 'blank'
      emerald.hp_cur                  = 0
      emerald.rox                     = 0
      emerald.description             = 'Emerald slumps over in his chair, completely lifeless. The color has drained from his eyes and a pallor has been cast over his face. His reign is no more.'
      throne_room.description         = 'Emerald\'s throne room feels much less imposing now that you have defeated him in mortal combat. Who knew?'
      throne_room.danger_level        = :none
      throne_room.monster_level_range = nil
      throne_room.monsters_abounding  = []
      throne.description              = 'The grim spectacle of Emerald\'s dead body drooping blankly in his chosen seat really brings down the market value of it, you guess.'
      
      # world knows you beat emerald
      world.emerald_beaten            = true

      # remove sparkly_thing from emerald
      emerald.inventory.remove_item('sparkly_thing')
      # give player sparkly_thing
      world.player.inventory.items.push(SparklyThing.new)

      # ending text
      puts '<^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^>'
      puts "You beat #{name}! You win! You receive the #{"SparklyThing(tm)".colorize(:magenta)} and become the true #{"Gem Warrior".colorize(:yellow)}!"
      puts '<^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^>'
      STDIN.getc

      puts 'Suddenly, an icy feeling shoots up your back. You feel lighter than air. Blackness takes over.'
      STDIN.getc

      # onto the queen
      Animation.run(phrase: MOVE_TEXT)
      puts

      return { type: 'move', data: 'Queen Room'}
    end
  end
end
