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

      monsters_vanquished = 0

      loop do
        monster = generate_monster
        battle = Battle.new({:world => self.world, :player => self.player, :monster => monster})
        battle.start(is_arena = true)

        monsters_vanquished += 1

        puts 'Do you wish to continue fighting in the Arena? (Y/N)'
        answer = gets.chomp.downcase

        case answer
        when 'yes', 'y'
          next
        else
          bonus_rox = monsters_vanquished * 25
          bonus_xp = monsters_vanquished * 10
          player.rox = player.rox + bonus_rox
          player.xp = player.xp + bonus_xp
          puts 'You decided you\'ve had enough of the exhausting Arena for one day and exit the main stage.'
          puts "You have gained #{bonus_rox} rox and #{bonus_xp} XP!"

          return print_arena_outro
        end
      end
    end

    private

    def generate_monster
      random_monster = nil

      loop do
        random_monster = world.monsters[rand(0..world.monsters.length-1)]

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
