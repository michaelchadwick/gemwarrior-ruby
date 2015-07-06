# lib/gemwarrior/evaluator.rb
# Evaluates prompt input

require 'pry'

require_relative 'arena'

module Gemwarrior
  class Evaluator
    # CONSTANTS
    ## MESSAGES
    PROGRAM_NAME                        = 'Gem Warrior'
    QUIT_MESSAGE                        = 'Thanks for playing the game. Until next time...'.colorize(:yellow)
    RESUME_MESSAGE                      = 'Back to adventuring!'.colorize(:green)

    GO_PARAMS                           = 'Options: north, east, south, west'
    CHANGE_PARAMS                       = 'Options: name'
    DEBUG_LIST_PARAMS                   = 'Options: monsters, items, locations'
    DEBUG_STAT_PARAMS                   = 'Options: atk_lo, atk_hi, strength, dexterity'

    ## ERRORS
    ERROR_COMMAND_INVALID               = 'That is not something the game yet understands.'

    ERROR_GO_PARAM_MISSING              = 'Just wander aimlessly? A direction would be nice.'
    ERROR_GO_PARAM_INVALID              = 'The place in that direction is far, far, FAR too dangerous. You should try a different way.'
    ERROR_ATTACK_PARAM_MISSING          = 'You cannot just "attack". You gotta choose something to attack.'
    ERROR_ATTACK_PARAM_INVALID          = 'That monster does not exist here or can\'t be attacked.'
    ERROR_TAKE_PARAM_MISSING            = 'You cannot just "take". You gotta choose something to take.'
    ERROR_USE_PARAM_MISSING             = 'You cannot just "use". You gotta choose something to use.'
    ERROR_USE_PARAM_INVALID             = 'You cannot use that, as it does not exist here or in your inventory.'
    ERROR_USE_PARAM_UNUSEABLE           = 'That object is not useable.'
    ERROR_DROP_PARAM_MISSING            = 'You cannot just "drop". You gotta choose something to drop.'
    ERROR_EQUIP_PARAM_MISSING           = 'You cannot just "equip". You gotta choose something to equip.'
    ERROR_UNEQUIP_PARAM_MISSING         = 'You cannot just "unequip". You gotta choose something to unequip.'
    ERROR_CHANGE_PARAM_MISSING          = 'You cannot just "change". You gotta choose something to change.'
    ERROR_CHANGE_PARAM_INVALID          = 'You cannot change that...yet.'
    ERROR_LIST_PARAM_MISSING            = 'You cannot just "list". You gotta choose something to list.'
    ERROR_LIST_PARAM_INVALID            = 'You cannot list that...yet.'
    ERROR_DEBUG_STAT_PARAM_MISSING      = 'You cannot just "change stats". You gotta choose a stat to change.'
    ERROR_DEBUG_STAT_PARAM_INVALID      = 'You cannot change that stat...yet.'
    ERROR_DEBUG_TELEPORT_PARAMS_MISSING = 'You cannot just "teleport". You gotta specify an x AND y coordinate, at least.'
    ERROR_DEBUG_TELEPORT_PARAMS_NEEDED  = 'You cannot just "teleport" to an x coordinate without a y coordinate.'
    ERROR_DEBUG_TELEPORT_PARAMS_INVALID = 'You cannot teleport there...yet.'

    attr_accessor :world,
                  :commands, :aliases, :extras, :cmd_descriptions,
                  :devcommands, :devaliases, :devextras, :devcmd_descriptions

    def initialize(world)
      self.world = world

      self.devcommands = %w(god beast list vars map stat teleport spawn)
      self.devaliases = %w(gd bs ls v m s tp sp)
      self.devextras = %w(st)
      self.devcmd_descriptions = [
        'Toggle god mode (i.e. invincible)',
        'Toggle beast mode (i.e. super strength)',
        'List all instances of a specific entity type',
        'List all the variables in the world',
        'Show a map of the world',
        'Change player stat',
        'Teleport to coordinates (5 0 0) or location name (\'Home\')',
        'Spawn random monster'
      ]

      self.commands = %w(character inventory rest look take use drop equip unequip go attack change help quit quit!)
      self.aliases = %w(c i r l t u d e ue g a ch h q qq)
      self.extras = %w(exit exit! x x fight f)
      self.cmd_descriptions = [
        'Display character information',
        'Look in your inventory',
        'Take a load off and regain HP',
        'Look around your current location',
        'Take item',
        'Use item (in inventory or environment)',
        'Drop item',
        'Equip item',
        'Unequip item',
        'Go in a direction',
        'Attack a monster',
        'Change something',
        'This help menu',
        'Quit w/ confirmation (also exit/x)',
        'Quit w/o confirmation (also exit!/xx)'
      ]
    end

    def evaluate(input)
      case input
      # Ctrl-D or empty command
      when nil, ''
        return
      # real command
      else
        tokens = input.split
        return ERROR_COMMAND_INVALID unless input_valid?(input)
      end

      command = tokens.first.downcase
      param1 = tokens[1]
      param2 = tokens[2]
      param3 = tokens[3]

      # dev commands
      if world.debug_mode
        case command
        when 'god', 'gd'
          return world.player.god_mode = !world.player.god_mode
        when 'beast', 'bs'
          return world.player.beast_mode = !world.player.beast_mode
        when 'vars', 'v'
          world.print_vars
        when 'list', 'ls'
          if param1.nil?
            puts ERROR_LIST_PARAM_MISSING
            return DEBUG_LIST_PARAMS
          else
            return world.list(param1, param2)
          end
        when 'map', 'm'
          world.print_map
        when 'stat', 'st', 's'
          if param1.nil?
            puts ERROR_DEBUG_STAT_PARAM_MISSING
            return DEBUG_STAT_PARAMS
          else
            case param1
            when 'hp_cur'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  world.player.hp_cur = param2 if param2 > 0
                end
              end
            when 'atk_lo'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  world.player.atk_lo = param2 if param2 >= 0
                end
              end
            when 'atk_hi'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  world.player.atk_hi = param2 if param2 >= 0
                end
              end
            when 'strength', 'str', 'st'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  if param2 >= 0
                    world.player.atk_lo = param2
                    world.player.atk_hi = param2
                  end
                end
              end
            when 'dexterity', 'dex', 'd'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  world.player.dexterity = param2 if param2 >= 0
                end
              end
            when 'rox', 'r', '$'
              unless param2.nil?
                param2 = param2.to_i
                world.player.rox = param2 if param2 >= 0 if param2.is_a? Numeric
              end
            else
              return ERROR_DEBUG_STAT_PARAM_INVALID
            end
          end
        when 'spawn', 'sp'
          cur_loc = world.location_by_coords(world.player.cur_coords)
          cur_loc.populate_monsters(world.monsters, true)
          return world.describe(cur_loc)
        when 'teleport', 'tp'
          if param1.nil?
            return ERROR_DEBUG_TELEPORT_PARAMS_MISSING
          else
            if (param1.to_i.to_s == param1)
              # we got at least an x coordinate
              if (param2.to_i.to_s == param2)
                # we got a y coordinate, too
                x_coord = param1.to_i
                y_coord = param2.to_i
                # grab the z coordinate, if present, otherwise default to current level
                z_coord = param3.to_i.to_s == param3 ? param3.to_i : world.player.cur_coords[:z]

                # check to make sure new location exists
                if world.location_by_coords(x: x_coord, y: y_coord, z: z_coord)
                  world.player.cur_coords = { x: x_coord, y: y_coord, z: z_coord }
                else
                  return ERROR_DEBUG_TELEPORT_PARAMS_INVALID
                end
              else
                # we only got an x coordinate
                return ERROR_DEBUG_TELEPORT_PARAMS_NEEDED
              end
            else
              # we got a place name instead, potentially
              place_to_match = tokens[1..tokens.length].join(' ').downcase
              locations = []
              world.locations.each do |l|
                locations << l.name.downcase
              end
              if locations.include?(place_to_match)
                world.player.cur_coords = world.location_coords_by_name(place_to_match)
              else
                return ERROR_DEBUG_TELEPORT_PARAMS_INVALID
              end
            end
            Animation.run(phrase: '** TELEPORT! **', speed: :insane)
            return world.describe(world.location_by_coords(world.player.cur_coords))
          end
        end
      end

      # normal commands
      case command
      when 'character', 'c'
        world.player.check_self(world.debug_mode)
      when 'inventory', 'i'
        if param1
          world.player.inventory.describe_item(param1)
        else
          world.player.list_inventory
        end
      when 'rest', 'r'
        world.player.rest(world)
      when 'look', 'l'
        if param1
          world.describe_entity(world.location_by_coords(world.player.cur_coords), param1)
        else
          world.describe(world.location_by_coords(world.player.cur_coords))
        end
      when 'take', 't'
        if param1.nil?
          ERROR_TAKE_PARAM_MISSING
        else
          world.player.inventory.add_item(world.location_by_coords(world.player.cur_coords), param1, world.player)
        end
      when 'use', 'u'
        if param1.nil?
          ERROR_USE_PARAM_MISSING
        else
          item_name = param1
          result = nil
          location_inventory = world.location_by_coords(world.player.cur_coords).items

          if location_inventory.map(&:name).include?(item_name)
            location_inventory.each do |i|
              if i.name.eql?(item_name)
                if i.useable
                  result = i.use(world.player)
                else
                  return ERROR_USE_PARAM_UNUSEABLE
                end
              end
            end
          elsif
            player_inventory = world.player.inventory.items
            if player_inventory.map(&:name).include?(item_name)
              player_inventory.each do |i|
                if i.name.eql?(item_name)
                  if i.useable
                    result = i.use(world.player)
                  else
                    return ERROR_USE_PARAM_UNUSEABLE
                  end
                end
              end
            end
          end

          if result.nil?
            ERROR_USE_PARAM_INVALID
          else
            case result[:type]
            when 'move'
              world.player.cur_coords = world.location_coords_by_name(result[:data])
              world.describe(world.location_by_coords(world.player.cur_coords))
            when 'move_dangerous'
              world.player.take_damage(rand(0..2))
              world.player.cur_coords = world.location_coords_by_name(result[:data])
              world.describe(world.location_by_coords(world.player.cur_coords))
            when 'dmg'
              world.player.take_damage(result[:data])
              return
            when 'rest', 'health'
              world.player.heal_damage(result[:data])
              return
            when 'action'
              case result[:data]
              when 'rest'
                world.player.rest(world)
              when 'map'
                world.print_map
              end
            when 'arena'
              arena = Arena.new(world: world, player: world.player)
              arena.start
              # return 'You enter the arena and fight some battles. It was cool, but not as cool as if it were actually implemented.'
            when 'item'
              world.location_by_coords(world.player.cur_coords).add_item(result[:data])
              return
            else
              return
            end
          end
        end
      when 'drop', 'd'
        if param1.nil?
          ERROR_DROP_PARAM_MISSING
        else
          world.player.inventory.remove_item(param1)
        end
      when 'equip', 'e'
        if param1.nil?
          ERROR_EQUIP_PARAM_MISSING
        else
          world.player.inventory.equip_item(param1)
        end
      when 'unequip', 'ue'
        if param1.nil?
          ERROR_UNEQUIP_PARAM_MISSING
        else
          world.player.inventory.unequip_item(param1)
        end
      when 'go', 'g'
        if param1.nil?
          puts ERROR_GO_PARAM_MISSING
          GO_PARAMS
        else
          direction = param1
          if world.can_move?(direction)
            world.player.go(world.locations, param1, world.sound)
            world.location_by_coords(world.player.cur_coords).checked_for_monsters = false
            world.describe(world.location_by_coords(world.player.cur_coords))
          else
            ERROR_GO_PARAM_INVALID
          end
        end
      when 'attack', 'a', 'fight', 'f'
        if param1.nil?
          ERROR_ATTACK_PARAM_MISSING
        else
          monster_name = param1
          if world.has_monster_to_attack?(monster_name)
            monster = world.location_by_coords(world.player.cur_coords).monster_by_name(monster_name)
            world.player.attack(world, monster)
          else
            ERROR_ATTACK_PARAM_INVALID
          end
        end
      when 'change', 'ch'
        if param1.nil?
          puts ERROR_CHANGE_PARAM_MISSING
          CHANGE_PARAMS
        else
          case param1
          when 'name'
            world.player.modify_name
          else
            ERROR_CHANGE_PARAM_INVALID
          end
        end
      when 'help', 'h'
        list_commands
      when 'quit', 'exit', 'q', 'x'
        puts 'You sure you want to quit? (y/n): '
        response = gets.chomp.downcase
        if response.eql?('y') || response.eql?('yes')
          puts QUIT_MESSAGE
          return 'exit'
        else
          puts RESUME_MESSAGE
        end
      when 'quit!', 'exit!', 'qq', 'xx'
        puts QUIT_MESSAGE
        return 'exit'
      else
        return
      end
    end

    private

    def print_separator
      puts '=================================================='
    end

    def list_commands
      i = 0
      print_separator
      commands.each do |cmd|
        puts " #{cmd.ljust(9)}, #{aliases[i].ljust(2)} -- #{cmd_descriptions[i]}"
        i += 1
      end
      print_separator

      if world.debug_mode
        puts ' DEBUG COMMANDS'
        print_separator
        i = 0
        devcommands.each do |cmd|
          puts " #{cmd.ljust(9)}, #{devaliases[i].ljust(2)} -- #{devcmd_descriptions[i]}"
          i += 1
        end
        print_separator
      end
    end

    def input_valid?(input)
      tokens = input.split
      command = tokens[0]
      commands_and_aliases = commands | aliases | extras

      if world.debug_mode
        commands_and_aliases = commands_and_aliases | devcommands | devaliases | devextras
      end

      if commands_and_aliases.include?(command.downcase)
        return true if tokens.size.between?(1, 4)
      elsif tokens.empty?
        return true
      end
    end
  end
end
