# lib/gemwarrior/game.rb
# Main launching point for Gem Warrior

require_relative 'world'
require_relative 'player'

require_relative 'repl'
require_relative 'evaluator'

module Gemwarrior
  class Game
    # CONSTANTS
    ## PLAYER DEFAULTS
    PLYR_LEVEL_DEFAULT = 1
    PLYR_XP_DEFAULT = 0
    PLYR_HP_CUR_DEFAULT = 10
    PLYR_HP_MAX_DEFAULT = 10
    PLYR_STAM_CUR_DEFAULT = 20
    PLYR_STAM_MAX_DEFAULT = 20
    PLYR_ATK_LO_DEFAULT = 1
    PLYR_ATK_HI_DEFAULT = 2
    PLYR_ROX_DEFAULT = 0

    attr_accessor :world, :eval, :repl
    
    def initialize
      # create new world and player
      self.world = World.new
      world.player = Player.new(
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
        world.loc_by_id(0)
      )

      # create the console
      self.eval = Evaluator.new(@world)
      self.repl = Repl.new(@world, @eval)

      # enter Jool!
      repl.start('look')
    end

  end
end
