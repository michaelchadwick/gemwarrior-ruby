# lib/gemwarrior/repl.rb
# My own, simple, Read Evaluate Print Loop module

require 'readline'
require 'os'

require_relative 'misc/wordlist'
require_relative 'evaluator'
require_relative 'version'

module Gemwarrior  
  class Repl
    # CONSTANTS
    ## MESSAGES
    QUIT_MESSAGE   = 'Temporal flux detected. Shutting down...'.colorize(:red)
    SPLASH_MESSAGE = 'Welcome to the land of *Jool*, where randomized fortune is just as likely as mayhem.'
    
    attr_accessor :world, :eval
    
    def initialize(world, evaluator)
      self.world  = world
      self.eval   = evaluator
    end

    def start(initialCommand = nil)
      setup_screen(initialCommand)

      # main loop
      loop do
        prompt
        begin
          input = read_line
          puts eval.evaluate(input)
        rescue Interrupt
          puts
          puts QUIT_MESSAGE
          exit(0)
        end
      end
    end
    
    private
    
    def clear_screen
      OS.windows? ? system('cls') : system('clear')
    end
    
    def print_logo
      if world.sound
        Music::cue([
          {:freq_or_note => 'A3,E4,C#5,F#5', :duration => 1000}
        ])
      end

      puts "/-+-+-+ +-+-+-+-+-+-+-\\".colorize(:yellow)
      puts '|G|E|M| |W|A|R|R|I|O|R|'.colorize(:yellow)
      puts "\\-+-+-+ +-+-+-+-+-+-+-/".colorize(:yellow)
    end
    
    def print_splash_message
      print_logo
      SPLASH_MESSAGE.length.times do print '=' end
      puts
      puts SPLASH_MESSAGE
      SPLASH_MESSAGE.length.times do print '=' end
      puts
    end
    
    def print_fortune
      noun1_values = WordList.new(world.use_wordnik, 'noun-plural')
      noun2_values = WordList.new(world.use_wordnik, 'noun-plural')
      noun3_values = WordList.new(world.use_wordnik, 'noun-plural')

      puts "* Remember: #{noun1_values.get_random_value} and #{noun2_values.get_random_value} are the key to #{noun3_values.get_random_value} *\n\n"
    end
    
    def print_help
      puts '* Basic functions: look, go, character, inventory, attack *'
      puts '* Type \'help\' for complete command list'
      puts '* Most commands can be abbreviated to their first letter *'
      puts
    end

    def setup_screen(initialCommand = nil)
      # welcome player to game
      clear_screen
      print_splash_message
      print_fortune
      print_help

      # hook to do something right off the bat
      puts eval.evaluate(initialCommand) unless initialCommand.nil?
    end
    
    def prompt
      prompt_template = "\n[LV:%3s][XP:%3s][ROX:%3s] -- [HP:%3s/%-3s][STM:%2s/%-2s] -- [%s @ %s]"
      prompt_vars_arr = [
        world.player.level,
        world.player.xp,
        world.player.rox,
        world.player.hp_cur, 
        world.player.hp_max,
        world.player.stam_cur,
        world.player.stam_max,
        world.player.name,
        world.location_by_coords(world.player.cur_coords).name
      ]
      puts (prompt_template % prompt_vars_arr).colorize(:yellow)
    end
    
    def read_line
      Readline.readline(' GW> ', true).to_s
    end
  end
end
