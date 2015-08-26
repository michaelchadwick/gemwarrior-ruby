# lib/gemwarrior/inventory.rb
# Collection of items a creature possesses

require_relative 'game_options'

module Gemwarrior
  class Inventory
    # CONSTANTS
    ERROR_ITEM_REMOVE_INVALID       = 'Your inventory does not contain that item, so you cannot drop it.'
    ERROR_ITEM_ADD_UNTAKEABLE       = 'That would be great if you could take that, wouldn\'t it? Huh!'
    ERROR_ITEM_ADD_INVALID          = 'That item cannot be added.'
    ERROR_ITEM_DESCRIBE_INVALID     = 'That does not seem to be in the inventory.'
    ERROR_ITEM_EQUIP_INVALID        = 'You do not possess anything called that to equip.'
    ERROR_ITEM_EQUIP_NONARMAMENT    = 'That item cannot be equipped.'
    ERROR_ITEM_UNEQUIP_INVALID      = 'You do not possess anything called that to unequip.'
    ERROR_ITEM_UNEQUIP_NONARMAMENT  = 'That item cannot be unequipped.'

    attr_accessor :items,
                  :weapon,
                  :armor

    def initialize(items = [], weapon = nil, armor = nil)
      self.items  = items
      self.weapon = weapon
      self.armor  = armor
    end

    def is_empty?
      self.items.nil? || self.items.empty?
    end

    def list_contents
      is_empty? ? '[empty]' : "#{self.items.map(&:name).join(', ')}"
    end

    def contains_item?(item_name)
      self.items.map{ |i| i.name.downcase }.include?(item_name.downcase)
    end

    def contains_battle_item?
      battle_item_found = false
      self.items.each do |i|
        battle_item_found = true if i.useable_battle
      end
      battle_item_found
    end

    def list_battle_items
      battle_items = []
      self.items.each do |i|
        battle_items.push(i) if i.useable_battle
      end
      battle_items
    end

    def describe_item(item_name)
      if contains_item?(item_name)
        self.items.each do |i|
          if i.name.eql?(item_name)
            if GameOptions.data['debug_mode']
              return i.describe_detailed
            else
              return i.describe
            end
          end
        end
      else
        ERROR_ITEM_DESCRIBE_INVALID
      end
    end

    def equip_item(item_name)
      if contains_item?(item_name)
        self.items.each do |i|
          if i.name.eql?(item_name)
            if i.equippable
              i.equipped = true
              if i.is_weapon
                self.weapon = i
                return "The #{i.name} has taken charge, and been equipped."
              elsif i.is_armor
                self.armor = i
                return "The #{i.name} has fortified, and has been equipped."
              end
            else
              return ERROR_ITEM_EQUIP_NONARMAMENT
            end
          end
        end
      else
        ERROR_ITEM_EQUIP_INVALID
      end
    end

    def unequip_item(item_name)
      if contains_item?(item_name)
        self.items.each do |i|
          if i.name.eql?(item_name)
            if i.equippable
              i.equipped = false
              if i.is_weapon
                self.weapon = nil
                return "The #{i.name} has been demoted to unequipped."
              elsif i.is_armor
                self.armor = nil
                return "The #{i.name} has been demoted to unequipped."
              end
            else
              return ERROR_ITEM_UNEQUIP_NONARMAMENT
            end
          end
        end
      else
        ERROR_ITEM_UNEQUIP_INVALID
      end
    end

    def add_item(item_name, cur_loc = nil, player = nil)
      if cur_loc.nil?
        self.items.push(item_name)
      else
        cur_loc.items.each do |i|
          if i.name.eql?(item_name)
            if i.takeable
              self.items.push(i)
              cur_loc.remove_item(item_name)

              # stats
              player.items_taken += 1

              return "Added #{item_name} to your increasing collection of bits of tid.".colorize(:green)
            else
              return ERROR_ITEM_ADD_UNTAKEABLE.colorize(:red)
            end
          end
        end
      end
      ERROR_ITEM_ADD_INVALID.colorize(:red)
    end

    def remove_item(item_name)
      self.items.delete_at(self.items.map(&:name).index(item_name) || self.items.length)
      unless self.weapon.nil?
        self.weapon = nil if self.weapon.name.eql?(item_name)
      end
    end

    def drop_item(item_name)
      if contains_item?(item_name)
        print "Are you sure you want to permanently throw away #{item_name}? (y/n) "
        answer = gets.chomp.downcase

        case answer
        when 'y', 'yes'
          remove_item(item_name)

          return "The #{item_name} has been thrown on the ground, but far out of reach, and you're much too lazy to go get it now, so it's as good as gone."
        else
          return "You decide to keep #{item_name} for now."
        end
      else
        ERROR_ITEM_REMOVE_INVALID
      end
    end
  end
end
