# lib/gemwarrior/game.rb
# Main launching point for Gem Warrior

require_relative 'entities/player'
require_relative 'world'
require_relative 'evaluator'
require_relative 'repl'

module Gemwarrior
  class Game
    # CONSTANTS
    ## PLAYER DEFAULTS
    PLYR_LEVEL_DEFAULT      = 1
    PLYR_XP_DEFAULT         = 0
    PLYR_HP_CUR_DEFAULT     = 30
    PLYR_HP_MAX_DEFAULT     = 30
    PLYR_STAM_CUR_DEFAULT   = 20
    PLYR_STAM_MAX_DEFAULT   = 20
    PLYR_ATK_LO_DEFAULT     = 1
    PLYR_ATK_HI_DEFAULT     = 2
    PLYR_DEFENSE_DEFAULT    = 5
    PLYR_DEXTERITY_DEFAULT  = 5
    PLYR_INVENTORY_DEFAULT  = Inventory.new
    PLYR_ROX_DEFAULT        = 0
    PLYR_CUR_LOC_ID_DEFAULT = 0

    attr_accessor :world, :eval, :repl
    
    def initialize
      # create new world and player
      self.world = World.new
      world.player = Player.new({
        :level              => PLYR_LEVEL_DEFAULT,
        :xp                 => PLYR_XP_DEFAULT,
        :hp_cur             => PLYR_HP_CUR_DEFAULT,
        :hp_max             => PLYR_HP_MAX_DEFAULT,
        :stam_cur           => PLYR_STAM_CUR_DEFAULT,
        :stam_max           => PLYR_STAM_MAX_DEFAULT,
        :atk_lo             => PLYR_ATK_LO_DEFAULT,
        :atk_hi             => PLYR_ATK_HI_DEFAULT,
        :defense            => PLYR_DEFENSE_DEFAULT,
        :dexterity          => PLYR_DEXTERITY_DEFAULT,
        :inventory          => PLYR_INVENTORY_DEFAULT,
        :rox                => PLYR_ROX_DEFAULT,
        :cur_loc            => world.loc_by_id(PLYR_CUR_LOC_ID_DEFAULT)
      })

      # create the console
      self.eval = Evaluator.new(world)
      self.repl = Repl.new(world, eval)

      # enter Jool!
      repl.start('look')
    end

  end
end
