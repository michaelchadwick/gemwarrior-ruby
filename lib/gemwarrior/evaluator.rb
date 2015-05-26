# lib/gemwarrior/evaluator.rb
# Evaluates prompt input

require 'pry'

module Gemwarrior  
  class Evaluator
    # CONSTANTS
    ## MESSAGES
    PROGRAM_NAME   = 'Gem Warrior'
    QUIT_MESSAGE   = 'Thanks for playing the game. Until next time...'
    RESUME_MESSAGE = 'Back to adventuring!'
    SEPARATOR      = '================================================================'
    CHANGE_PARAMS  = 'Options: name'
    
    ## ERRORS
    ERROR_COMMAND_INVALID      = 'That\'s not something the game yet understands.'
    ERROR_LIST_PARAM_MISSING   = 'You can\'t just "list". You gotta choose something to list.'
    ERROR_CHANGE_PARAM_MISSING = 'Ch-ch-changes...aren\'t happening because you didn\'t specify what to change.'
    ERROR_CHANGE_PARAM_INVALID = 'You can\'t change that...yet.'
    ERROR_GO_PARAM_MISSING     = 'Just wander aimlessly? A direction would be nice.'
    ERROR_ATTACK_PARAM_MISSING = 'You can\'t just "attack". You gotta choose something to attack.'
    ERROR_TAKE_PARAM_MISSING   = 'You can\'t just "take". You gotta choose something to take.'
    ERROR_DROP_PARAM_MISSING   = 'You can\'t just "drop". You gotta choose something to drop.'
    
    attr_accessor :world, :commands, :aliases, :descriptions
    
    def initialize(world)
      self.world = world
      self.commands = %w(character inventory list rest look take drop go attack change help quit exit quit! exit!)
      self.aliases = %w(c i ls r l t d g a ch h q x qq xx)
      self.descriptions = [
        'Display character information',
        'Look in your inventory',
        'List all the objects of a type that exist in the world',
        'Take a load off and regain stamina',
        'Look around your current location',
        'Take item',
        'Drop item',
        'Go in a direction',
        'Attack a monster',
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
      
      unless input_valid?(input)
        return ERROR_COMMAND_INVALID
      end
      
      command = tokens.first.downcase
      param = tokens[1]

      case command
      when 'character', 'c'
        world.player.check_self
      when 'inventory', 'i'
        if param
          world.player.inventory.describe_item(param)
        else
          world.player.list_inventory
        end
      when 'list', 'ls'
        if param.nil?
          ERROR_LIST_PARAM_MISSING
        else
          world.list(param)
        end
      when 'rest', 'r'
        world.player.rest
      when 'look', 'l'
        if param
          world.player.cur_loc.describe_entity(param)
        else
          world.player.cur_loc.describe
        end
      when 'take', 't'
        if param.nil?
          ERROR_TAKE_PARAM_MISSING
        else
          world.player.inventory.add_item(world.player.cur_loc, param)
        end
      when 'drop', 'd'
        if param.nil?
          ERROR_DROP_PARAM_MISSING
        else
          world.player.inventory.remove_item(param)
        end  
      when 'go', 'g'
        if param.nil?
          ERROR_GO_PARAM_MISSING
        else
          world.player.go(world.locations, param)
        end
      when 'attack', 'a'
        if param.nil?
          ERROR_ATTACK_PARAM_MISSING
        else
          world.player.attack(param)
        end
      when 'change', 'ch'
        if param.nil?
          puts ERROR_CHANGE_PARAM_MISSING
          puts CHANGE_PARAMS
        else
          case param
          when 'name'
            world.player.modify_name
          else
            ERROR_CHANGE_PARAM_INVALID
          end
        end
      when 'help', 'h'
        list_commands
      when 'quit', 'exit', 'q', 'x'
        puts "You sure you want to quit? (y/n): "
        response = gets.chomp.downcase
        if (response.eql?("y") || response.eql?("yes"))
          puts QUIT_MESSAGE
          exit(0)
        else
          puts RESUME_MESSAGE
        end
      when 'quit!', 'exit!', 'qq', 'xx'
        puts QUIT_MESSAGE
        exit(0)
      else
        return
      end
    end

    private
    
    def print_separator
      puts SEPARATOR
    end
    
    def list_commands
      i = 0
      print_separator
      commands.each do |cmd|
        puts " #{cmd}, #{aliases[i]}\n -- #{descriptions[i]}"
        i = i + 1
      end
      print_separator
    end
    
    def input_valid?(input)
      tokens = input.split
      commands_and_aliases = commands | aliases
      if commands_and_aliases.include?(tokens.first.downcase)
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
