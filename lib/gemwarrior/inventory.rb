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
    VOWELS                          = 'aeiou'

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

    # non-English-like contents of inventory for simple lists
    def contents
      if is_empty?
        nil
      else
        item_hash = {}
        self.items.map(&:name).each do |i|
          i_sym = i.to_sym
          if item_hash.keys.include? i_sym
            item_hash[i_sym] += 1
          else
            item_hash[i_sym] = 1
          end
        end

        # one item? return string
        if item_hash.length == 1
          i = item_hash.keys.join
          q = item_hash.values.join.to_i
          return q > 1 ? "#{q} #{i}s" : i
        # multiple items? return array of strings to mush together
        else
          item_arr = []
          item_hash.each do |i, q|
            if q > 1
              item_arr.push("#{i.to_s.colorize(:yellow)}#{'s'.colorize(:yellow)} x#{q}")
            else
              item_arr.push(i)
            end
          end

          return item_arr.join(', ')
        end
      end
    end

    # English-like sentence summary of inventory
    def list_contents
      if is_empty?
        'You possess nothing.'
      else
        # build hash of inventory's items
        item_hash = {}
        self.items.map(&:name).each do |i|
          i_sym = i.to_sym
          if item_hash.keys.include? i_sym
            item_hash[i_sym] += 1
          else
            item_hash[i_sym] = 1
          end
        end

        # one item? return string
        if item_hash.length == 1
          i = item_hash.keys.join
          q = item_hash.values.join.to_i
          if q > 1
            return "You have #{q} #{i.to_s.colorize(:yellow)}#{'s'.colorize(:yellow)}."
          else
            article = VOWELS.include?(i[0]) ? 'an' : 'a'
            return "You have #{article} #{i.to_s.colorize(:yellow)}."
          end
        # multiple items? return array of strings to mush together
        else
          item_list_text = 'You have '
          item_arr = []
          item_hash.each do |i, q|
            if q > 1
              item_arr.push("#{q} #{i.to_s.colorize(:yellow)}#{'s'.colorize(:yellow)}")
            else
              article = VOWELS.include?(i[0]) ? 'an' : 'a'
              item_arr.push("#{article} #{i.to_s.colorize(:yellow)}")
            end
          end

          item_arr[-1].replace("and #{item_arr[-1]}.")

          return item_list_text << item_arr.join(', ')
        end
      end
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
                return "The #{i.name.colorize(:yellow)} has taken charge, and been equipped."
              elsif i.is_armor
                self.armor = i
                return "The #{i.name.colorize(:yellow)} has fortified, and has been equipped."
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
                return "The #{i.name.colorize(:yellow)} has been demoted to unequipped."
              elsif i.is_armor
                self.armor = nil
                return "The #{i.name.colorize(:yellow)} has been demoted to unequipped."
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

              return "#{"Added".colorize(:green)} #{item_name.colorize(:yellow)} #{"to your increasing collection of bits of tid".colorize(:green)}."
            else
              return ERROR_ITEM_ADD_UNTAKEABLE.colorize(:red)
            end
          end
        end
      end
      ERROR_ITEM_ADD_INVALID.colorize(:red)
    end

    def drop_item(item_name, cur_loc)
      if contains_item?(item_name)
        remove_item(item_name)
        cur_loc.add_item(item_name)
        "You dropped #{item_name.colorize(:yellow)}."
      else
        ERROR_ITEM_REMOVE_INVALID
      end
    end

    def remove_item(item_name)
      self.items.delete_at(self.items.map(&:name).index(item_name) || self.items.length)
      unless self.weapon.nil?
        self.weapon = nil if self.weapon.name.eql?(item_name)
      end
    end
  end
end
