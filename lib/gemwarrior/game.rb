# lib/gemwarrior/game.rb
# Main launching point for Gem Warrior

require 'colorize'
require 'matrext'

require_relative 'entities/player'
require_relative 'entities/items/herb'
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
    PLAYER_INVENTORY_DEBUG    = Inventory.new([Herb.new])
    PLAYER_ROX_DEFAULT        = 0
    PLAYER_ROX_DEBUG          = 300

    attr_accessor :world, :evaluator, :repl

    def initialize(options)
      # create new world and player
      self.world            = World.new

      start_stats = PlayerLevels::get_level_stats(1)

      world.debug_mode      = options.fetch(:debug_mode)
      world.sound_enabled   = options.fetch(:sound_enabled)
      world.sound_volume    = options.fetch(:sound_volume)
      world.use_wordnik     = options.fetch(:use_wordnik)
      world.new_game        = options.fetch(:new_game)
      world.extra_command   = options.fetch(:extra_command)

      world.player = Player.new({
        description:  PLAYER_DESC_DEFAULT,
        level:        start_stats[:level],
        xp:           start_stats[:xp_start],
        hp_cur:       start_stats[:hp_max],
        hp_max:       start_stats[:hp_max],
        stam_cur:     start_stats[:stam_max],
        stam_max:     start_stats[:stam_max],
        atk_lo:       start_stats[:atk_lo],
        atk_hi:       start_stats[:atk_hi],
        defense:      start_stats[:defense],
        dexterity:    start_stats[:dexterity],
        inventory:    world.debug_mode ? PLAYER_INVENTORY_DEBUG : PLAYER_INVENTORY_DEFAULT,
        rox:          world.debug_mode ? PLAYER_ROX_DEBUG : PLAYER_ROX_DEFAULT,
        cur_coords:   world.location_coords_by_name('Home'),

        god_mode:     options.fetch(:god_mode),
        beast_mode:   options.fetch(:beast_mode),
        use_wordnik:  options.fetch(:use_wordnik)
      })

      # create options file if not existing
      update_options_file(world)
      
      # create the console
      self.evaluator  = Evaluator.new(world)
      self.repl       = Repl.new(self, world, evaluator)

      # enter Jool!
      repl.start('look', world.extra_command)
    end

    def get_log_file_path
      "#{Dir.home}/.gemwarrior_log"
    end

    def get_options_file_path
      "#{Dir.home}/.gemwarrior_options"
    end

    def update_options_file(world)
      File.open(get_options_file_path, 'w') do |f|
        f.puts "sound_enabled:#{world.sound_enabled}"
        f.puts "sound_volume:#{world.sound_volume}"
        f.puts "use_wordnik:#{world.use_wordnik}"
      end
    end
  end
end
