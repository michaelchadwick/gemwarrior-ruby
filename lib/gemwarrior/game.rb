# lib/game.rb

require 'highline'
require 'cli-console'

require_relative 'constants'
require_relative 'version'
require_relative 'player'
require_relative 'location'
require_relative 'gwui'

module Gemwarrior
  class Game
    
    def initialize
      @player = Player.new
      @locations = create_locations
      @locationID = 0
      @current_location = @locations[@locationID]
      
      # create the console
      io = HighLine.new
      shell = GWShell.new(@player)
      console = CLI::Console.new(io)
      
      console.addCommand('character', shell.method(:character), 'Character evaluation')
      console.addCommand('inventory', shell.method(:inventory), 'Look in inventory')
      console.addCommand('rest', shell.method(:rest), 'Take a rest')
      console.addCommand('look', shell.method(:look), 'Look around')
      
      console.addHelpCommand('help', 'Help')
      console.addExitCommand('exit', 'Exit from program')
    
      console.addAlias('c', 'character')
      console.addAlias('i', 'inventory')
      console.addAlias('r', 'rest')
      console.addAlias('l', 'look')
      console.addAlias('quit', 'exit')
      
      console.start("*#{Gemwarrior::PROGRAM_NAME}* [%s]\n> ", [Gemwarrior::VERSION])
    end
    
    def create_locations
      @locations = []
      @locations.push(Location.new(0, "Home", "The little, unimportant, decrepit hut that you live in."))
      @locations.push(Location.new(1, "Cave", "A nearby, dank cavern, filled with stacktites, stonemites, and rocksites."))
      @locations.push(Location.new(2, "Forest", "Trees exist here, in droves."))
      @locations.push(Location.new(3, "Emerald's Sky Tower", "The craziest guy that ever existed is around here somewhere amongst the cloud floors, snow walls, and ethereal vibe."))
    end
  end
end