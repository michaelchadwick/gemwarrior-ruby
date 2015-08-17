# lib/gemwarrior/arena.rb
# Arena series of battles

require_relative 'misc/player_levels'
require_relative 'battle'

module Gemwarrior
  class Arena
    attr_accessor :world, :player

    def initialize(options)
      self.world    = options.fetch(:world)
      self.player   = options.fetch(:player)
    end

    def start
      print_arena_intro

      arena_monsters_vanquished = 0

      loop do
        monster = generate_monster
        battle = Battle.new(world: world, player: player, monster: monster)
        result = battle.start(is_arena = true)

        if result.eql?('death')
          return 'death'
        end

        arena_monsters_vanquished += 1

        puts
        print 'Do you wish to continue fighting in the Arena? (y/n) '
        answer = gets.chomp.downcase

        case answer
        when 'y', 'yes'
          next
        else
          bonus_rox = arena_monsters_vanquished * 25
          bonus_xp = arena_monsters_vanquished * 10
          player.rox = player.rox + bonus_rox
          player.xp = player.xp + bonus_xp
          puts 'You decided you\'ve had enough of the exhausting Arena for one day and exit the main stage.'
          puts "You defeated #{arena_monsters_vanquished} monsters!"
          puts "You have gained #{bonus_rox} rox and #{bonus_xp} XP!"

          return print_arena_outro
        end
      end
    end

    private

    def generate_monster
      random_monster = nil

      loop do
        random_monster = world.monsters[rand(0..world.monsters.length - 1)].clone

        unless random_monster.is_boss
          break
        end
      end

      return random_monster.clone
    end

    def print_arena_intro
      puts '**************************'.colorize(:red)
      puts '* YOU ENTER THE ARENA!!! *'.colorize(:red)
      puts '**************************'.colorize(:red)
    end

    def print_arena_outro
      puts '**************************'.colorize(:red)
      puts '* YOU LEAVE THE ARENA!!! *'.colorize(:red)
      puts '**************************'.colorize(:red)
    end
  end
end
