# lib/gemwarrior/entities/location.rb
# Entity::Location
# Place in the game

require_relative 'entity'
require_relative '../game_options'

module Gemwarrior
  class Location < Entity
    # CONSTANTS
    DANGER_LEVEL              = { none: 0, low: 15, moderate: 30, high: 55, assured: 100 }
    ERROR_ITEM_ADD_INVALID    = 'That item cannot be added to the location\'s inventory.'
    ERROR_ITEM_REMOVE_INVALID = 'That item cannot be removed as it does not exist here.'

    attr_accessor :coords,
                  :paths,
                  :danger_level,
                  :monster_level_range,
                  :items,
                  :monsters_abounding,
                  :bosses_abounding,
                  :checked_for_monsters

    def initialize(options)
      self.name                 = options.fetch(:name)
      self.description          = options.fetch(:description)
      self.coords               = options.fetch(:coords)
      self.paths                = options.fetch(:paths)
      self.danger_level         = options.fetch(:danger_level)
      self.monster_level_range  = options.fetch(:monster_level_range)
      self.items                = options.fetch(:items)
      self.monsters_abounding   = options.fetch(:monsters_abounding)
      self.bosses_abounding     = options.fetch[:bosses_abounding]
      self.checked_for_monsters = false
    end

    def describe
      desc_text =  name.ljust(30).upcase.colorize(:green)
      desc_text << coords.values.to_a.to_s.colorize(:white)
      desc_text << " DL[#{danger_level.to_s.ljust(8)}] ".colorize(:white) if GameOptions.data['debug_mode']
      desc_text << " MLR[#{monster_level_range.to_s.ljust(6)}] ".colorize(:white) if GameOptions.data['debug_mode']
      desc_text << "\n"
      desc_text << "#{description}".colorize(:white)
      desc_text
    end

    def describe_detailed
      desc_text =  "#{name_display.ljust(36).colorize(:yellow)} #{coords.values.to_a.to_s.colorize(:white)}\n"
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}\n".colorize(:white)
      desc_text << "DANGER_LEVEL       : #{danger_level}\n".colorize(:white)
      desc_text << "MONSTER_LEVEL_RANGE: #{monster_level_range}\n".colorize(:white)
      desc_text
    end

    def contains_item?(item_name)
      self.items.map{|i| i.name.downcase}.include?(item_name.downcase)
    end

    def has_monster?(monster_name)
      monsters_abounding.map{|m| m.name.downcase}.include?(monster_name.downcase)
    end

    def has_boss?(boss_name)
      bosses_abounding.map{|b| b.name.downcase}.include?(boss_name.downcase)
    end

    def add_item(item_name_to_add)
      all_items = GameItems.data | GameWeapons.data | GameArmor.data
      all_items.each do |game_item|
        if game_item.name.eql?(item_name_to_add)
          self.items.push(game_item)
          return
        end
      end
      return LOCATION_INVENTORY_ADD_ITEM_INVALID
    end

    def remove_item(item_name)
      if contains_item?(item_name)
        self.items.delete_at(items.index(items.find { |i| i.name.downcase == item_name.downcase }))
      else
        ERROR_ITEM_REMOVE_INVALID
      end
    end

    def remove_monster(name)
      monsters_abounding.reject! { |monster| monster.name == name }
      bosses_abounding.reject! { |boss| boss.name == name }
    end

    def has_loc_to_the?(direction)
      case direction
      when 'n'
        direction = 'north'
      when 'e'
        direction = 'east'
      when 's'
        direction = 'south'
      when 'w'
        direction = 'west'
      end
      paths[direction.to_sym]
    end

    def monster_by_name(monster_name)
      monsters_list = monsters_abounding | bosses_abounding

      monsters_list.each do |m|
        if m.name.downcase.eql?(monster_name.downcase)
          return m.clone
        end
      end
    end

    def checked_for_monsters?
      checked_for_monsters
    end

    def should_spawn_monster?
      found = false
      unless danger_level.eql?(:none)
        max = DANGER_LEVEL[danger_level]
        trigger_values = 0..max
        actual_value = rand(1..100)

        if trigger_values.include?(actual_value)
          found = true
        end
      end
      return found
    end

    def list_items
      if items.empty?
        []
      else
        # build hash out of location's items
        item_hash = {}
        self.items.map(&:name).each do |i|
          i_sym = i.to_sym
          if item_hash.keys.include? i_sym
            item_hash[i_sym] += 1
          else
            item_hash[i_sym] = 1
          end
        end

        # one item? return single element array
        if item_hash.length == 1
          i = item_hash.keys
          q = item_hash.values.join.to_i
          return q > 1 ? ["#{q} #{i}s"] : i
        # multiple items? build an array of strings
        else
          item_arr = []
          item_hash.each do |i, q|
            if q > 1
              item_arr.push("#{i.to_s.colorize(:yellow)}#{'s'.colorize(:yellow)} x#{q}")
            else
              item_arr.push(i)
            end
          end

          return item_arr
        end
      end
    end

    def list_monsters
      monsters_abounding.length > 0 ? monsters_abounding.map(&:name) : []
    end

    def list_bosses
      bosses_abounding.length > 0 ? bosses_abounding.map(&:name_display) : []
    end

    def list_paths
      valid_paths = []
      self.paths.each do |key, value|
        if value
          valid_paths.push(key.to_s)
        end
      end
      return valid_paths
    end

    def list_actionable_words
      actionable_words = []
      actionable_words.push(monsters_abounding.map(&:name)) unless monsters_abounding.empty?
      actionable_words.push(bosses_abounding.map(&:name))   unless bosses_abounding.empty?
      actionable_words.push(items.map(&:name))              unless items.empty?
      actionable_words.join(', ')
    end

    def populate_monsters(monsters_available, spawn = false)
      if should_spawn_monster? || spawn
        self.checked_for_monsters = true unless spawn
        self.monsters_abounding = [] unless spawn
        random_monster = nil

        # get random non-boss monster
        loop do
          random_monster = monsters_available[rand(0..monsters_available.length-1)].clone

          if spawn
            break
          else
            unless random_monster.is_boss || !self.monster_level_range.include?(random_monster.level)
              break
            end
          end
        end

        monsters_abounding.push(random_monster)
      else
        return nil
      end
    end
  end
end
