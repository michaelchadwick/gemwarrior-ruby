# lib/gemwarrior/evaluator.rb
# Evaluates prompt input

require 'pry'

require_relative 'constants'

module Gemwarrior  
  class Evaluator
    include Errors
    
    attr_reader :cur_msg
    
    def initialize(world)
      @world = world
      @cur_msg = nil
      @commands = %w(character inventory rest look take world monsters go change help quit exit)
      @aliases = %w(c i r l t w m g ch h q x)
      @descriptions = [
        'Display character information',
        'Look in your inventory',
        'Take a load off and regain stamina',
        'Look around your current location',
        'List all locations in the world',
        'List all the monsters in the world',
        'Go in a directions',
        'Change something',
        'This help menu',
        'Quit the game',
        'Exit the game (very different, of course)'
      ]
    end
    
    def print_separator
      SEPARATOR
    end
    
    def list_commands
      i = 0
      print_separator
      @commands.each do |cmd|
        puts "#{cmd}, #{@aliases[i]} - #{@descriptions[i]}"
        i = i + 1
      end
      print_separator
    end
    
    def evaluate(input)
      tokens = input.split
      
      unless valid?(input)
        puts ERROR_COMMAND_INVALID
        return
      end
      
      command = tokens.first
      param = tokens[1]

      case command
      when @commands[0], @aliases[0] # character
        @world.player.check_self
      when @commands[1], @aliases[1] # inventory
        if param
          @world.player.inventory.describe_item(param)
        else
          @world.player.list_inventory
        end
      when @commands[2], @aliases[2] # rest
        @world.player.rest
      when @commands[3], @aliases[3] # look
        if param
          @world.player.cur_loc.describe_item(param)
        else
          @world.player.cur_loc.describe
        end
      when @commands[4], @aliases[4] # take
        unless param.nil?
          @world.player.inventory.add_item(@world.player.cur_loc, param)
        else
          ERROR_TAKE_PARAM_MISSING
        end
      when @commands[5], @aliases[5] # world
        @world.list_locations
      when @commands[6], @aliases[6] # monsters
        @world.list_monsters
      when @commands[7], @aliases[7] # go
        if param.nil?
          ERROR_GO_DIR_MISSING
        else
          @world.player.go(@world.locations, param)
        end
      when @commands[8], @aliases[8] # change
        if param.nil?
          puts ERROR_CHANGE_PARAM_MISSING
          puts CHANGE_PARAMS
        else
          case param
          when 'name'
            @world.player.modify_name
          else
            ERROR_CHANGE_PARAM_INVALID
          end
        end
      when @commands[9], @aliases[9] # help
        list_commands
      when @commands[10..11], @aliases[10] # quit/exit
        puts QUIT_MESSAGE
        exit(0)
      end
    end
    
    def valid?(input)
      tokens = input.split
      result = false
      commands_and_aliases = @commands | @aliases
      if commands_and_aliases.include?(tokens.first)
        if tokens.size.between?(1,2)
          return true
        end
      elsif tokens.empty?
        return true
      end
      result
    end
    
  end
end
