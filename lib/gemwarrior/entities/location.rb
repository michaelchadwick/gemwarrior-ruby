# lib/gemwarrior/entities/location.rb
# Place in the game

require_relative 'entity'

module Gemwarrior
  class Location < Entity
    # CONSTANTS
    ## HASHES
    DANGER_LEVEL = {:none => 0, :low => 15, :moderate => 30, :high => 55, :assured => 100}

    ## ERRORS
    ERROR_LOCATION_ITEM_REMOVE_INVALID      = 'That item cannot be removed as it does not exist here.'

    attr_accessor :coords, :locs_connected, :danger_level, :monster_level_range, :items, 
                  :monsters_abounding, :bosses_abounding, :checked_for_monsters

    def initialize(options)
      self.name                 = options.fetch(:name)
      self.description          = options.fetch(:description)
      self.coords               = options.fetch(:coords)
      self.locs_connected       = options.fetch(:locs_connected)
      self.danger_level         = options.fetch(:danger_level)
      self.monster_level_range  = options.fetch(:monster_level_range)
      self.items                = options.fetch(:items)
      self.monsters_abounding   = []
      self.bosses_abounding     = options[:bosses_abounding]
      self.checked_for_monsters = false
    end

    def status(debug_mode = false)
      status_text =  name.ljust(30).upcase.colorize(:green)
      status_text << coords.values.to_a.to_s.colorize(:white)
      status_text << " DL[#{danger_level.to_s.ljust(8)}] ".colorize(:white) if debug_mode
      status_text << " MLR[#{monster_level_range.to_s.ljust(6)}] ".colorize(:white) if debug_mode
      status_text << "\n#{description}\n".colorize(:white)
    end

    def has_item?(item_name)
      items.map{|i| i.name.downcase}.include?(item_name)
    end

    def has_monster?(monster_name)
      monsters_abounding.map{|m| m.name.downcase}.include?(monster_name)
    end

    def has_boss?(boss_name)
      bosses_abounding.map{|b| b.name.downcase}.include?(boss_name)
    end

    def add_item(item_name)
      Dir.glob('lib/gemwarrior/items/*.rb').each do |item|
        require_relative item[item.index('/', item.index('/')+1)+1..item.length]
      end

      self.items.push(eval(item_name).new)
    end

    def remove_item(item_name)
      if has_item?(item_name)
        items.reject! { |item| item.name == item_name }
      else
        ERROR_LOCATION_ITEM_REMOVE_INVALID
      end
    end

    def remove_monster(name)
      monsters_abounding.reject! { |monster| monster.name == name }
      bosses_abounding.reject! { |monster| monster.name == name }
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
      locs_connected[direction.to_sym]
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
      if items.length > 0
        items.map(&:name)
      else
        []
      end
    end

    def list_monsters
      if monsters_abounding.length > 0
        monsters_abounding.map(&:name)
      else
        []
      end
    end

    def list_bosses
      if bosses_abounding.length > 0
        bosses_abounding.map(&:name)
      else
        []
      end
    end

    def list_paths
      valid_paths = []
      locs_connected.each do |key, value|
        if value
          valid_paths.push(key.to_s)
        end
      end
      return valid_paths
    end

    def list_actionable_words
      actionable_words =  []
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
          random_monster = monsters_available[rand(0..monsters_available.length-1)]

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
