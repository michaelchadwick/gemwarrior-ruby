# lib/gemwarrior/game.rb
# Main launching point for Gem Warrior

require 'colorize'
require 'matrext'
require 'feep'

require_relative 'entities/player'
require_relative 'misc/player_levels'
require_relative 'misc/animation'
require_relative 'misc/music'
require_relative 'world'
require_relative 'evaluator'
require_relative 'repl'
require_relative 'inventory'

module Gemwarrior
  class Game
    include PlayerLevels

    # CONSTANTS
    ## PLAYER DEFAULTS
    PLAYER_DESC_DEFAULT       = 'Picked to do battle against a wizened madman for a shiny something or other for world-saving purposes.'
    PLAYER_INVENTORY_DEFAULT  = Inventory.new
    PLAYER_ROX_DEFAULT        = 0

    attr_accessor :world, :eval, :repl

    def initialize(options)
      # create new world and player
      self.world            = World.new

      start_stats = PlayerLevels::get_level_stats(1)

      world.debug_mode      = options.fetch(:debug_mode)
      world.use_wordnik     = options.fetch(:use_wordnik)
      world.sound           = options.fetch(:sound)

      world.player = Player.new({
        :description        => PLAYER_DESC_DEFAULT,
        :level              => start_stats[:level],
        :xp                 => start_stats[:xp_start],
        :hp_cur             => start_stats[:hp_max],
        :hp_max             => start_stats[:hp_max],
        :stam_cur           => start_stats[:stam_max],
        :stam_max           => start_stats[:stam_max],
        :atk_lo             => start_stats[:atk_lo],
        :atk_hi             => start_stats[:atk_hi],
        :defense            => start_stats[:defense],
        :dexterity          => start_stats[:dexterity],
        :inventory          => PLAYER_INVENTORY_DEFAULT,
        :rox                => world.debug_mode ? 300 : PLAYER_ROX_DEFAULT,
        :cur_coords         => world.location_coords_by_name('Home'),

        :god_mode           => options.fetch(:god_mode),
        :beast_mode         => options.fetch(:beast_mode),
        :use_wordnik        => options.fetch(:use_wordnik)
      })

      # create the console
      self.eval = Evaluator.new(world)
      self.repl = Repl.new(world, eval)

      # enter Jool!
      repl.start('look')
    end

  end
end
