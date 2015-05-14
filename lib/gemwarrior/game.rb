# lib/gemwarrior/game.rb
# Main launching point for Gem Warrior

require 'highline'
require 'highline/import'
require 'cli-console'
require 'pry'

require_relative 'constants'
require_relative 'version'
require_relative 'world'
require_relative 'shell'
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
      console.addCommand('go', shell.method(:go), 'Go in a direction')
      console.addCommand('world', shell.method(:world), 'List locations in world')
      console.addCommand('monsters', shell.method(:monsters), 'List monsters in world')
      console.addCommand('change name', shell.method(:change_name), 'Change hero\'s name')
      
      console.addHelpCommand('help', 'Help')
      console.addExitCommand('exit', 'Exit from program')
    end
    
    def init_shell_aliases(console)
      console.addAlias('c', 'character')
      console.addAlias('i', 'inventory')
      console.addAlias('r', 'rest')
      console.addAlias('l', 'look')
      console.addAlias('g', 'go')
      console.addAlias('w', 'world')
      console.addAlias('m', 'monsters')
      console.addAlias('quit', 'exit')
    end

    public

    def initialize
      # create new world and player
      @world = World.new
      @player = Player.new(
        PLYR_LEVEL_DEFAULT,
        PLYR_XP_DEFAULT,
        PLYR_HP_CUR_DEFAULT,
        PLYR_HP_MAX_DEFAULT,
        PLYR_STAM_CUR_DEFAULT,
        PLYR_STAM_MAX_DEFAULT,
        PLYR_ATK_LO_DEFAULT,
        PLYR_ATK_HI_DEFAULT,
        Inventory.new,
        PLYR_ROX_DEFAULT,
        @world.loc_by_id(0)
      )
      @world.player = @player

      # create the console
      io = HighLine.new
      shell = Shell.new(@world)
      console = CLI::Console.new(io)
      init_shell_commands(shell, console)
      init_shell_aliases(console)

      prompt_template =  "*****#{Gemwarrior::PROGRAM_NAME} v%s*****\n"
      prompt_template += "[LV:%3s][XP:%3s][HP:%3s|%-3s][STM:%2s|%-2s] -- [%s@%s]\n> "
      prompt_vars_arr = [
        Gemwarrior::VERSION,
        @world.player.level,
        @world.player.xp,
        @world.player.hp_cur, 
        @world.player.hp_max,
        @world.player.stam_cur,
        @world.player.stam_max,
        @world.player.name,
        @world.player.cur_loc.name
      ]

      # enter Jool!
      console.start(prompt_template, prompt_vars_arr)
    end

  end
end