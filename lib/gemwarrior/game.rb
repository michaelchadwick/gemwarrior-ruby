# lib/gemwarrior/game.rb
# Main launching point for Gem Warrior

require 'colorize'
require 'matrext'

require_relative 'misc/animation'
require_relative 'misc/music'
require_relative 'world'
require_relative 'evaluator'
require_relative 'repl'
require_relative 'inventory'
require_relative 'game_options'

module Gemwarrior
  class Game
    # CONSTANTS
    INVENTORY_DEFAULT             = Inventory.new
    INVENTORY_DEBUG               = Inventory.new([Herb.new])
    ROX_DEFAULT                   = 0
    ROX_DEBUG                     = 300

    attr_accessor :world, :evaluator, :repl,
                  :monsters, :items

    def initialize(options)
      # set game options
      GameOptions.add 'beast_mode', options.fetch(:beast_mode)
      GameOptions.add 'debug_mode', options.fetch(:debug_mode)
      GameOptions.add 'god_mode', options.fetch(:god_mode)
      GameOptions.add 'sound_enabled', options.fetch(:sound_enabled)
      GameOptions.add 'sound_system', options.fetch(:sound_system)
      GameOptions.add 'sound_volume', options.fetch(:sound_volume)
      GameOptions.add 'use_wordnik', options.fetch(:use_wordnik)

      # add classes for monsters and items to game
      init_monsters
      init_items

      # create new world based on default template
      self.world               = init_world

      # update some player aspects to make more dynamic
      world.player.name        = world.player.generate_name
      world.player.face        = world.player.generate_face
      world.player.hands       = world.player.generate_hands
      world.player.mood        = world.player.generate_mood
      world.player.inventory   = GameOptions.data['debug_mode'] ? INVENTORY_DEBUG : INVENTORY_DEFAULT
      world.player.rox         = GameOptions.data['debug_mode'] ? ROX_DEBUG : ROX_DEFAULT
      
      world.duration           = { mins: 0, secs: 0, ms: 0 }
      world.emerald_beaten     = false

      # create options file if not existing
      update_options_file

      # create the console
      self.evaluator  = Evaluator.new(world)
      self.repl       = Repl.new(self, world, evaluator)

      # enter Jool!
      repl.start('look', options.fetch(:extra_command),  options.fetch(:new_skip), options.fetch(:resume_skip))
    end

    def update_options_file
      File.open(GameOptions.data['options_file_path'], 'w') do |f|
        f.puts "sound_enabled:#{GameOptions.data['sound_enabled']}"
        f.puts "sound_system:#{GameOptions.data['sound_system']}"
        f.puts "sound_volume:#{GameOptions.data['sound_volume']}"
        f.puts "use_wordnik:#{GameOptions.data['use_wordnik']}"
      end
    end

    private

    def init_monsters
      Dir.glob(File.expand_path('../entities/monsters/*.rb', __FILE__)).each do |item|
        require_relative item
      end
      Dir.glob(File.expand_path('../entities/monsters/bosses/*.rb', __FILE__)).each do |item|
        require_relative item
      end

      self.monsters = [
        Alexandrat.new,
        Amberoo.new,
        Amethystle.new,
        Apatiger.new,
        Aquamarine.new,
        Bloodstorm.new,
        Citrinaga.new,
        Coraliz.new,
        Cubicat.new,
        Diaman.new,
        Emerald.new,
        Garynetty.new
      ]
    end

    def init_items
      Dir.glob(File.expand_path('../entities/items/*.rb', __FILE__)).each do |item|
        require_relative item
      end
    end

    def init_world
      mode = GameOptions.data['save_file_mode']

      if mode.eql?('Y')
        if File.exist?(GameOptions.data['default_world_path_yaml'])
          File.open(GameOptions.data['default_world_path_yaml'], 'r') do |f|
            return YAML::load(f)
          end
        else
          puts "Error: cannot load #{GameOptions.data['default_world_path_yaml']}."
        end
      else
        if File.exist?(GameOptions.data['default_world_path_bin'])
          File.open(GameOptions.data['default_world_path_bin'], 'r') do |f|
            return Marshal::load(f)
          end
        else
          puts "Error: cannot load #{GameOptions.data['default_world_path_bin']}."
        end
      end
    end
  end
end
