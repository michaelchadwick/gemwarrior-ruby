# lib/gemwarrior/game.rb
# Main launching point for Gem Warrior

require 'pry'

require_relative 'constants'
require_relative 'version'
require_relative 'world'
require_relative 'evaluator'
require_relative 'repl'
require_relative 'player'

module Gemwarrior
  class Game
    private

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
      @eval = Evaluator.new(@world)
      @repl = Repl.new(@world, @eval)

      # enter Jool!
      @repl.start('look')
    end

  end
end
