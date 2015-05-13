# lib/gemwarrior/game.rb
# Main launching point for Gem Warrior

require 'highline'
require 'cli-console'

require_relative 'constants'
require_relative 'version'
require_relative 'world'
require_relative 'gwui'
require_relative 'player'
require_relative 'location'

module Gemwarrior
  class Game

    private

    def init_shell_commands(shell, console)
      console.addCommand('character', shell.method(:character), 'Character evaluation')
      console.addCommand('inventory', shell.method(:inventory), 'Look in inventory')
      console.addCommand('rest', shell.method(:rest), 'Take a rest')
      console.addCommand('look', shell.method(:look), 'Look around')
      console.addCommand('world', shell.method(:world), 'List locations in world')
      
      console.addHelpCommand('help', 'Help')
      console.addExitCommand('exit', 'Exit from program')

      console.addAlias('c', 'character')
      console.addAlias('i', 'inventory')
      console.addAlias('r', 'rest')
      console.addAlias('l', 'look')
      console.addAlias('w', 'world')
      console.addAlias('quit', 'exit')
    end

    public

    @world = nil
    @player = nil

    def initialize
      # create new world and player
      @world = World.new
      @player = Player.new(1, 0, 10, 10, 1, 2, Inventory.new, 0, @world, @world.loc_by_id(1))

      # create the console
      io = HighLine.new
      shell = GWShell.new(@world, @player)
      console = CLI::Console.new(io)
      init_shell_commands(shell, console)

      # enter Jool!
      console.start("*#{Gemwarrior::PROGRAM_NAME}* [%s]\n> ", [Gemwarrior::VERSION])
    end

  end
end