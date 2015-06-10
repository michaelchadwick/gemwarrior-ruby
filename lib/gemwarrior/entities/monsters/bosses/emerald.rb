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
      0.upto(9) do print '<^>' end
      print "\n"
      puts  "You beat #{name}! You win!\n"
      print "You receive the "
      print "SparklyThing(tm)".colorize(:magenta)
      print " and become the true "
      print "Gem Warrior".colorize(:yellow)
      print "!\n"
      print "You decide to ignore "
      print "Queen Ruby".colorize(:red)
      print " and take your spoils back home\n"
      print "where you live out the rest of your days staring at it, wondering\n"
      print "what it was all about.\n\n"
      puts  "Thank you for playing. Goodbye."
      0.upto(9) do print '<^>' end      
      puts
    end
  end
end
