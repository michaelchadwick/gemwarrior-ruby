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
require_relative 'game_options'

module Gemwarrior
  class Game
    include PlayerLevels

    # CONSTANTS
    PLAYER_DESC_DEFAULT       = 'Picked to do battle against a wizened madman for a shiny something or other for world-saving purposes.'
    PLAYER_INVENTORY_DEFAULT  = Inventory.new
    PLAYER_INVENTORY_DEBUG    = Inventory.new([Herb.new])
    PLAYER_ROX_DEFAULT        = 0
    PLAYER_ROX_DEBUG          = 300

    attr_accessor :world, :evaluator, :repl

    def initialize(options)
      # set game options
      GameOptions.add 'beast_mode', options.fetch(:beast_mode)
      GameOptions.add 'debug_mode', options.fetch(:debug_mode)
      GameOptions.add 'god_mode', options.fetch(:god_mode)
      GameOptions.add 'sound_enabled', options.fetch(:sound_enabled)
      GameOptions.add 'sound_volume', options.fetch(:sound_volume)
      GameOptions.add 'use_wordnik', options.fetch(:use_wordnik)
      
      # create new world and player
      start_stats  = PlayerLevels::get_level_stats(1)

      self.world   = World.new

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
        inventory:    GameOptions.data['debug_mode'] ? PLAYER_INVENTORY_DEBUG : PLAYER_INVENTORY_DEFAULT,
        rox:          GameOptions.data['debug_mode'] ? PLAYER_ROX_DEBUG : PLAYER_ROX_DEFAULT,
        cur_coords:   world.location_coords_by_name('Home')
      })

      # create options file if not existing
      update_options_file
      
      # create the console
      self.evaluator  = Evaluator.new(world)
      self.repl       = Repl.new(self, world, evaluator)

      # enter Jool!
      repl.start('look', options.fetch(:extra_command),  options.fetch(:new_game))
    end

    def update_options_file
      File.open(GameOptions.data['options_file_path'], 'w') do |f|
        f.puts "sound_enabled:#{GameOptions.data['sound_enabled']}"
        f.puts "sound_volume:#{GameOptions.data['sound_volume']}"
        f.puts "use_wordnik:#{GameOptions.data['use_wordnik']}"
      end
    end
  end
end
