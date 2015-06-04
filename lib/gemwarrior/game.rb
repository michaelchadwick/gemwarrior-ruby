# lib/gemwarrior/game.rb
# Main launching point for Gem Warrior

require_relative 'entities/player'
require_relative 'world'
require_relative 'evaluator'
require_relative 'repl'
require_relative 'inventory'

module Gemwarrior
  class Game
    # CONSTANTS
    ## PLAYER DEFAULTS
    PLAYER_DESC_DEFAULT       = 'Picked to do battle against a wizened madman for a shiny something or other for world-saving purposes.'
    PLAYER_LEVEL_DEFAULT      = 1
    PLAYER_XP_DEFAULT         = 0
    PLAYER_HP_CUR_DEFAULT     = 30
    PLAYER_HP_MAX_DEFAULT     = 30
    PLAYER_STAM_CUR_DEFAULT   = 20
    PLAYER_STAM_MAX_DEFAULT   = 20
    PLAYER_ATK_LO_DEFAULT     = 1
    PLAYER_ATK_HI_DEFAULT     = 2
    PLAYER_DEFENSE_DEFAULT    = 5
    PLAYER_DEXTERITY_DEFAULT  = 5
    PLAYER_INVENTORY_DEFAULT  = Inventory.new
    PLAYER_ROX_DEFAULT        = 0

    attr_accessor :world, :eval, :repl
    
    def initialize
      # create new world and player
      self.world = World.new
      world.player = Player.new({
        :description        => PLAYER_DESC_DEFAULT,
        :level              => PLAYER_LEVEL_DEFAULT,
        :xp                 => PLAYER_XP_DEFAULT,
        :hp_cur             => PLAYER_HP_CUR_DEFAULT,
        :hp_max             => PLAYER_HP_MAX_DEFAULT,
        :stam_cur           => PLAYER_STAM_CUR_DEFAULT,
        :stam_max           => PLAYER_STAM_MAX_DEFAULT,
        :atk_lo             => PLAYER_ATK_LO_DEFAULT,
        :atk_hi             => PLAYER_ATK_HI_DEFAULT,
        :defense            => PLAYER_DEFENSE_DEFAULT,
        :dexterity          => PLAYER_DEXTERITY_DEFAULT,
        :inventory          => PLAYER_INVENTORY_DEFAULT,
        :rox                => PLAYER_ROX_DEFAULT,
        :cur_coords         => world.location_coords_by_name('Home')
      })

      # create the console
      self.eval = Evaluator.new(world)
      self.repl = Repl.new(world, eval)

      # enter Jool!
      repl.start('look')
    end

  end
end
