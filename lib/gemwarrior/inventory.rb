# lib/gemwarrior/inventory.rb
# Collection of items a creature possesses

module Gemwarrior
  class Inventory
    # CONSTANTS
    ## ERRORS
    ERROR_ITEM_REMOVE_INVALID     = 'Your inventory does not contain that item, so you cannot drop it.'
    ERROR_ITEM_ADD_UNTAKEABLE     = 'That would be great if you could take that thing, wouldn\'t it? Well, it\'s not so great for you right now.'
    ERROR_ITEM_ADD_INVALID        = 'That item does not exist here.'
    ERROR_ITEM_DESCRIBE_INVALID   = 'You do not possess that.'
    ERROR_ITEM_EQUIP_INVALID      = 'You do not have anything called that to equip.'
    ERROR_ITEM_EQUIP_NONWEAPON    = 'That cannot be equipped as a weapon.'
    ERROR_ITEM_UNEQUIP_INVALID    = 'You do not have anything called that to unequip.'
    ERROR_ITEM_UNEQUIP_NONWEAPON  = 'That cannot be unequipped.'

    attr_accessor :items, :weapon

    def initialize(items = [], weapon = nil)
      self.items = items
      self.weapon = weapon
    end

    def list_contents
      if items.nil? || items.empty?
        return contents_text = '[empty]'
      else
        return contents_text = "#{items.map(&:name).join ', '}"
      end
    end

    def contains_item?(item_name)
      items.map(&:name).include?(item_name)
    end

    def describe_item(item_name)
      if contains_item?(item_name)
        items.each do |i|
          if i.name.eql?(item_name)
            return i.description
          end
        end
      else
        ERROR_ITEM_DESCRIBE_INVALID
      end
    end

    def equip_item(item_name)
      if contains_item?(item_name)
        items.each do |i|
          if i.name.eql?(item_name)
            if i.equippable
              i.equipped = true
              self.weapon = i
              return "The #{i.name} has taken charge, and been equipped."
            else
              ERROR_ITEM_EQUIP_NONWEAPON
            end
          end
        end
      else
        ERROR_ITEM_EQUIP_INVALID
      end
    end

    def unequip_item(item_name)
      if contains_item?(item_name)
        items.each do |i|
          if i.name.eql?(item_name)
            if i.equippable
              i.equipped = false
              self.weapon = nil
              return "The #{i.name} has been demoted to unequipped."
            else
              ERROR_ITEM_UNEQUIP_NONWEAPON
            end
          end
        end
      else
        ERROR_ITEM_UNEQUIP_INVALID
      end
    end

    def add_item(cur_loc, item_name, player)
      cur_loc.items.each do |i|
        if i.name.eql?(item_name)
          if i.takeable
            items.push(i)
            cur_loc.remove_item(item_name)

            # stats
            player.items_taken += 1

            return "Added #{item_name} to your increasing collection of bits of tid."
          else
            return ERROR_ITEM_ADD_UNTAKEABLE
          end
        end
      end
      ERROR_ITEM_ADD_INVALID
    end

    def remove_item(item_name)
      if contains_item?(item_name)
        items.reject! { |item| item.name == item_name }

        self.weapon = nil if self.weapon.name.eql?(item_name)
        
        return "The #{item_name} has been thrown on the ground, but far out of reach, and you're much too lazy to go get it now, so it's as good as gone."
      else
        ERROR_ITEM_REMOVE_INVALID
      end
    end
  end
end
