# lib/game.rb

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
      
      console.addHelpCommand('help', 'Help')
      console.addExitCommand('exit', 'Exit from program')

      console.addAlias('c', 'character')
      console.addAlias('i', 'inventory')
      console.addAlias('r', 'rest')
      console.addAlias('l', 'look')
      console.addAlias('quit', 'exit')
    end

    public

    @world = nil
    @player = nil

    def initialize
      # create new world and player
      @world = World.new
      @player = Player.new(1, 0, 10, 10, 1, 2, Inventory.new, 0, @world, @world.loc_by_id(0))

      #@player.current_location = @locations[0] if @player.current_location.nil?

      # create the console
      io = HighLine.new
      shell = GWShell.new(@player)
      console = CLI::Console.new(io)
      init_shell_commands(shell, console)

      # enter Jool!
      console.start("*#{Gemwarrior::PROGRAM_NAME}* [%s]\n> ", [Gemwarrior::VERSION])
    end

  end
end