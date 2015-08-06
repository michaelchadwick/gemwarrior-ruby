# lib/gemwarrior/entities/monsters/bosses/emerald.rb
# Emerald boss monster

require_relative '../../monster'
require_relative '../../items/sparklything'

module Gemwarrior
  class Emerald < Monster
    attr_accessor :defeated_text

    def initialize
      self.name           = 'Emerald'
      self.description    = 'A wily, beefy, tower of a man, champion of both wisdom and strength, sporting a constant glint in his eyes.'
      self.face           = 'gleaming'
      self.hands          = 'tantalizing'
      self.mood           = 'enraged'

      self.level          = 15
      self.hp_cur         = rand((level * 2)..(level * 3))
      self.hp_max         = hp_cur
      self.atk_lo         = rand(level..(level * 2.5).floor)
      self.atk_hi         = rand((level * 2.5).floor..(level * 3).floor)
      self.defense        = rand(5..7)
      self.dexterity      = rand(8..10)

      self.inventory      = Inventory.new(items = [SparklyThing.new])
      self.rox            = rand((level * 2)..(level * 3))
      self.xp             = rand(level..(level * 2))

      self.battlecry      = 'Ha ha ha ha ha! Prepare yourself: today your whole life crumbles!'
      self.is_boss        = true
      self.defeated_text  = defeated_text
    end

    def defeated_text
      text =  "<^><^><^><^><^><^><^><^><^><^>\n"
      text <<  "You beat #{name}! You win!\n"
      text << 'You receive the '
      text << 'SparklyThing(tm)'.colorize(:magenta)
      text << ' and become the true '
      text << 'Gem Warrior'.colorize(:yellow)
      text << "!\n"
      text << 'You decide to ignore '
      text << 'Queen Ruby'.colorize(:red)
      text << " and take your spoils back home\n"
      text << "where you live out the rest of your days staring at it, wondering\n"
      text << "what it was all about.\n\n"
      text << "Thank you for playing. Goodbye.\n"
      text << "<^><^><^><^><^><^><^><^><^><^>\n"
    end
  end
end
