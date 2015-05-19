# lib/gemwarrior/inventory.rb
# Collection of items a creature possesses

module Gemwarrior
  class Inventory
    include Errors
    
    def initialize(inventory = [])
      @inventory = inventory
    end
    
    def list_contents
      contents_text = "You check your inventory"
      if @inventory.empty?
        return contents_text << ERROR_INVENTORY_EMPTY
      else
        @item_names = []
        @inventory.each do |i|
          @item_names.push(i.name)
        end
        return contents_text << ": #{@inventory.map(&:name).join ', '}"
      end
    end
    
    def describe_item(item_name)
      if @inventory.map(&:name).include?(item_name)
        @inventory.each do |i|
          if i.name.eql?(item_name)
            return "#{i.description}"
          end
        end
      else
        ERROR_ITEM_INVENTORY_INVALID
      end
    end
        
    def add_item(cur_loc, item_name)
      cur_loc.items.each do |i|
        if i.name.eql?(item_name)
          if i.takeable
            @inventory.push(i)
            cur_loc.remove_item_from_location(item_name)
            return "Added #{item_name} to your increasing collection of bits of tid.\n"
          else
            ERROR_TAKE_ITEM_UNTAKEABLE
          end
        end
      end
      ERROR_TAKE_ITEM_INVALID
    end
    
    def remove_item(item_name)
      if inventory.include?(item_name)
        @inventory.delete(item_name)
        puts "#{item} has been thrown on the ground, but far out of reach, and you're much too lazy to go get it now, so it's as good as gone.\n"
      else
        puts ERROR_INVENTORY_REMOVE_INVALID
      end
    end
  end
end
