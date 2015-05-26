# lib/gemwarrior/repl.rb
# My own, simple, Read Evaluate Print Loop module

require 'readline'
require 'os'

require_relative 'version'
require_relative 'evaluator'
require_relative 'wordlist'

module Gemwarrior  
  class Repl
    # CONSTANTS
    ## MESSAGES
    QUIT_MESSAGE   = 'Temporal flux detected. Shutting down...'
    SPLASH_MESSAGE = 'Welcome to Gem Warrior, where randomized fortune is just as likely as mayhem.'
    
    attr_accessor :world, :eval
    
    def initialize(world, evaluator)
      self.world = world
      self.eval = evaluator
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
      if OS.windows?
        system('cls')
      else
        system('clear')
      end
    end
    
    def print_splash_message
      0.upto(SPLASH_MESSAGE.length-1) do print "=" end
      print "\n"
      puts SPLASH_MESSAGE
      0.upto(SPLASH_MESSAGE.length-1) do print "=" end
      print "\n"
    end
    
    def print_fortune
      noun1_values = WordList.new('noun-plural')
      noun2_values = WordList.new('noun-plural')
      noun3_values = WordList.new('noun-plural')

      puts "* Remember: #{noun1_values.get_random_value} and #{noun2_values.get_random_value} are the key to #{noun3_values.get_random_value} *\n\n"
    end

    def setup_screen(initialCommand = nil)
      # welcome player to game
      clear_screen
      print_splash_message
      print_fortune 

      # hook to do something right off the bat
      puts eval.evaluate(initialCommand) unless initialCommand.nil?
    end
    
    def prompt
      prompt_template = "\n[LV:%3s][XP:%3s][HP:%3s|%-3s][STM:%2s|%-2s][ROX:%3s] -- [%s @ %s]"
      prompt_vars_arr = [
        world.player.level,
        world.player.xp,
        world.player.hp_cur, 
        world.player.hp_max,
        world.player.stam_cur,
        world.player.stam_max,
        world.player.rox,
        world.player.name,
        world.player.cur_loc.name
      ]
      puts (prompt_template % prompt_vars_arr)
    end
    
    def read_line
      Readline.readline(' GW> ', true).to_s
    end
  end
end
