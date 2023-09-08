# lib/gemwarrior/game.rb
# Main launching point for Gem Warrior

require 'colorize'
require 'matrext'

require_relative 'entities/armor/iron_helmet'
require_relative 'entities/items/herb'
require_relative 'entities/weapons/dagger'
require_relative 'entities/player'
require_relative 'misc/animation'
require_relative 'misc/audio'
require_relative 'misc/formatting'
require_relative 'misc/hr'
require_relative 'evaluator'
require_relative 'game_assets'
require_relative 'game_options'
require_relative 'inventory'
require_relative 'repl'
require_relative 'world'

module Gemwarrior
  class Game
    # CONSTANTS
    INVENTORY_DEFAULT               = Inventory.new
    INVENTORY_DEBUG                 = Inventory.new([Herb.new, Herb.new, Herb.new])
    ROX_DEFAULT                     = 0
    ROX_DEBUG                       = 300

    attr_accessor :world,
                  :evaluator,
                  :repl,
                  :monsters,
                  :weapons

    def initialize(options)
      # set game options
      self.init_game_options(options)

      # add classes for creatures, monsters, people, items, weapons, and armor to game
      # also add them to the global GameAssets
      self.init_creatures
      self.init_monsters
      self.init_people
      self.init_items
      self.init_weapons
      self.init_armor

      # create new world based on yaml/marshall data
      self.world                    = init_world

      # spawn bosses inside world
      self.init_bosses

      # update some aspects of world's player to make more dynamic
      self.world.player.name        = world.player.generate_name
      self.world.player.face        = world.player.generate_face
      self.world.player.hands       = world.player.generate_hands
      self.world.player.mood        = world.player.generate_mood
      self.world.player.inventory   = GameOptions.data['debug_mode'] ? INVENTORY_DEBUG : INVENTORY_DEFAULT
      self.world.player.rox         = GameOptions.data['debug_mode'] ? ROX_DEBUG : ROX_DEFAULT

      # set some global variables
      self.world.duration           = { mins: 0, secs: 0, ms: 0 }
      self.world.emerald_beaten     = false
      self.world.shifty_to_jewel    = false
      self.world.shifty_has_jeweled = false

      # mark home as visited
      self.world.location_by_name('home').visited = true

      # create options file if not existing
      self.update_options_file

      # create the console
      self.evaluator                = Evaluator.new(world)
      self.repl                     = Repl.new(self, world, evaluator)

      # enter Jool!
      self.repl.start('look', options.fetch(:extra_command), options.fetch(:new_skip), options.fetch(:resume_skip))
    end

    def update_options_file
      File.open(GameOptions.data['options_file_path'], 'w') do |f|
        f.puts "fight_completion:#{GameOptions.data['fight_completion']}"
        f.puts "sound_enabled:#{GameOptions.data['sound_enabled']}"
        f.puts "sound_system:#{GameOptions.data['sound_system']}"
        f.puts "sound_volume:#{GameOptions.data['sound_volume']}"
        f.puts "use_wordnik:#{GameOptions.data['use_wordnik']}"
      end
    end

    private

    # convert an entity filename to a class so it can be added to game asset singleton registry
    def file_to_class(filename)
      filename_to_string = Formatting.upstyle(filename.split('/').last.split('.')[0], no_space: true)
      Gemwarrior.const_get(filename_to_string).new
    end

    def init_game_options(options)
      GameOptions.add 'beast_mode',       options.fetch(:beast_mode)
      GameOptions.add 'debug_mode',       options.fetch(:debug_mode)
      GameOptions.add 'fight_completion', options.fetch(:fight_completion)
      GameOptions.add 'god_mode',         options.fetch(:god_mode)
      GameOptions.add 'sound_enabled',    options.fetch(:sound_enabled)
      GameOptions.add 'sound_system',     options.fetch(:sound_system)
      GameOptions.add 'sound_volume',     options.fetch(:sound_volume)
      GameOptions.add 'use_wordnik',      options.fetch(:use_wordnik)

      # require needed files for selected sound_system if sound_enabled
      if GameOptions.data['sound_enabled']
        Audio.init
      end
    end

    def init_bosses
      ## Pain Quarry
      world.location_by_name('pain_quarry-southeast').bosses_abounding.push(Gemwarrior.const_get('Garynetty').new)
      world.location_by_name('pain_quarry-east').bosses_abounding.push(Gemwarrior.const_get('Garynetty').new)
      world.location_by_name('pain_quarry-central').bosses_abounding.push(Gemwarrior.const_get('Garynetty').new)
      world.location_by_name('pain_quarry-south').bosses_abounding.push(Gemwarrior.const_get('Garynetty').new)
      world.location_by_name('pain_quarry-west').bosses_abounding.push(Gemwarrior.const_get('Garynetty').new)
      world.location_by_name('pain_quarry-northwest').bosses_abounding.push(Gemwarrior.const_get('Garynetty').new)
      world.location_by_name('pain_quarry-north').bosses_abounding.push(Gemwarrior.const_get('Garynetty').new)
      ## River Bridge
      world.location_by_name('river_bridge').bosses_abounding.push(Gemwarrior.const_get('Jaspern').new)
      ## Throne Room
      world.location_by_name('sky_tower-throne_room').bosses_abounding.push(Gemwarrior.const_get('Emerald').new)
    end

    def init_creatures
      Dir.glob(File.expand_path('../entities/creatures/*.rb', __FILE__)).each do |creature|
        require_relative creature
        GameCreatures.add(file_to_class(creature))
      end
    end

    def init_monsters
      Dir.glob(File.expand_path('../entities/monsters/*.rb', __FILE__)).each do |monster|
        require_relative monster
        GameMonsters.add(file_to_class(monster))
      end
      Dir.glob(File.expand_path('../entities/monsters/bosses/*.rb', __FILE__)).each do |boss|
        require_relative boss
        GameMonsters.add(file_to_class(boss))
      end
    end

    def init_people
      Dir.glob(File.expand_path('../entities/people/*.rb', __FILE__)).each do |person|
        require_relative person
        GamePeople.add(file_to_class(person))
      end
    end

    def init_items
      Dir.glob(File.expand_path('../entities/items/*.rb', __FILE__)).each do |item|
        require_relative item
        GameItems.add(file_to_class(item))
      end
    end

    def init_weapons
      Dir.glob(File.expand_path('../entities/weapons/*.rb', __FILE__)).each do |weapon|
        require_relative weapon
        GameWeapons.add(file_to_class(weapon))
      end
    end

    def init_armor
      Dir.glob(File.expand_path('../entities/armor/*.rb', __FILE__)).each do |armor|
        require_relative armor
        GameArmor.add(file_to_class(armor))
      end
    end

    def init_world
      mode = GameOptions.data['save_file_mode']

      if mode.eql?('Y')
        if File.exist?(GameOptions.data['world_yaml_path'])
          File.open(GameOptions.data['world_yaml_path'], 'r') do |f|
            return YAML.unsafe_load(f)
          end
        else
          puts "Error: cannot load #{GameOptions.data['world_yaml_path']}."
        end
      else
        if File.exist?(GameOptions.data['world_bin_path'])
          File.open(GameOptions.data['world_bin_path'], 'r') do |f|
            return Marshal.load(f)
          end
        else
          puts "Error: cannot load #{GameOptions.data['world_bin_path']}."
        end
      end
    end
  end
end
