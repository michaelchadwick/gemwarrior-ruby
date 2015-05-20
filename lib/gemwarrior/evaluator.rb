# lib/gemwarrior/evaluator.rb
# Evaluates prompt input

require 'pry'

require_relative 'constants'

module Gemwarrior  
  class Evaluator
    private
    
    def print_separator
      puts SEPARATOR
    end
    
    def list_commands
      i = 0
      print_separator
      @commands.each do |cmd|
        puts " #{cmd}, #{@aliases[i]}\n -- #{@descriptions[i]}"
        i = i + 1
      end
      print_separator
    end
    
    public
  
    include Errors

    def initialize(world)
      @world = world
      @commands = %w(character inventory rest look take drop world monsters go change help quit exit quit! exit!)
      @aliases = %w(c i r l t d w m g ch h q x qq xx)
      @descriptions = [
        'Display character information',
        'Look in your inventory',
        'Take a load off and regain stamina',
        'Look around your current location',
        'Take item',
        'Drop item',
        'List all locations in the world',
        'List all the monsters in the world',
        'Go in a direction',
        'Change something',
        'This help menu',
        'Quit w/ confirmation',
        'Exit w/ confirmation (very different, of course)',
        'Quit w/o confirmation',
        'Exit w/o confirmation (very, very different, of course)'
      ]
    end
    
    def evaluate(input)
      if input.nil?
        return
      end
    
      tokens = input.split
      
      unless valid?(input)
        return ERROR_COMMAND_INVALID
      end
      
      command = tokens.first
      param = tokens[1]

      case command
      when 'character', 'c'
        @world.player.check_self
      when 'inventory', 'i'
        if param
          @world.player.inventory.describe_item(param)
        else
          @world.player.list_inventory
        end
      when 'rest', 'r'
        @world.player.rest
      when 'look', 'l'
        if param
          @world.player.cur_loc.describe_item(param)
        else
          @world.player.cur_loc.describe
        end
      when 'take', 't'
        if param.nil?
          ERROR_TAKE_PARAM_MISSING
        else
          @world.player.inventory.add_item(@world.player.cur_loc, param)
        end
      when 'drop', 'd'
        if param.nil?
          ERROR_DROP_PARAM_MISSING
        else
          @world.player.inventory.remove_item(param)
        end  
      when 'world', 'world'
        @world.list_locations
      when 'monsters', 'm'
        @world.list_monsters
      when 'go', 'g'
        if param.nil?
          ERROR_GO_DIR_MISSING
        else
          @world.player.go(@world.locations, param)
        end
      when 'change', 'ch'
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
      when 'help', 'h'
        list_commands
      when 'quit', 'exit', 'q', 'x'
        puts "You sure you want to quit? (y/n): "
        response = gets.chomp
        if (response.downcase.eql?("y") || response.downcase.eql?("yes"))
          puts QUIT_MESSAGE
          exit(0)
        else
          puts RESUME_MESSAGE
        end
      when 'qq', 'xx'
        puts QUIT_MESSAGE
        exit(0)
      else
        return
      end
    end
    
    def valid?(input)
      tokens = input.split
      commands_and_aliases = @commands | @aliases
      if commands_and_aliases.include?(tokens.first)
        if tokens.size.between?(1,2)
          return true
        end
      elsif tokens.empty?
        return true
      end
      return false
    end
    
  end
end
