# lib/gemwarrior/repl.rb
# My own, simple, Read Evaluate Print Loop module

require 'readline'
require 'pry'

require_relative 'evaluator'

module Gemwarrior
  class Repl
    def initialize(world, evaluator)
      @world = world
      @eval = evaluator
    end
    
    def prompt
      prompt_template =  "\n*****#{Gemwarrior::PROGRAM_NAME} v%s*****\n"
      prompt_template += "[LV:%3s][XP:%3s][HP:%3s|%-3s][STM:%2s|%-2s] -- [%s @ %s]"
      prompt_vars_arr = [
        Gemwarrior::VERSION,
        @world.player.level,
        @world.player.xp,
        @world.player.hp_cur, 
        @world.player.hp_max,
        @world.player.stam_cur,
        @world.player.stam_max,
        @world.player.name,
        @world.player.cur_loc.name
      ]
      puts (prompt_template % prompt_vars_arr)
    end
    
    def read_line
      Readline.readline(' > ', true)
    end
    
    def start(initialCommand = nil)
      # welcome player to game
      puts SPLASH_MESSAGE
      system('clear')
      # hook to do something right off the bat
      @eval.evaluate(initialCommand) unless initialCommand.nil?
      
      # main loop
      loop do
        puts @eval.cur_msg unless @eval.cur_msg.nil?
        prompt
        input = read_line
        @eval.evaluate(input)
      end
    end
  end
end
