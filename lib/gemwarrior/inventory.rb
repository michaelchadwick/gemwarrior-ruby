# lib/gemwarrior/inventory.rb
# Collection of items a creature possesses

module Gemwarrior
  class Inventory
    # CONSTANTS
    ## ERRORS
    ERROR_INVENTORY_EMPTY       = '...and find you currently have diddly-squat, which is nothing.'
    ERROR_ITEM_REMOVE_INVALID   = 'Your inventory does not contain that item, so you can\'t drop it.'
    ERROR_ITEM_ADD_UNTAKEABLE   = 'That would be great if you could take that thing, wouldn\'t it? Well, it\'s not so great for you right now.'
    ERROR_ITEM_ADD_INVALID      = 'That item doesn\'t exist here.'
    ERROR_ITEM_DESCRIBE_INVALID = 'You don\'t possess that.'
    
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
        ERROR_ITEM_DESCRIBE_INVALID
      end
    end
        
    def add_item(cur_loc, item_name)
      cur_loc.items.each do |i|
        if i.name.eql?(item_name)
          if i.takeable
            @inventory.push(i)
            cur_loc.remove_item(item_name)
            return "Added #{item_name} to your increasing collection of bits of tid.\n"
          else
            return ERROR_ITEM_ADD_UNTAKEABLE
          end
        end
      end
      ERROR_ITEM_ADD_INVALID
    end
    
    def remove_item(item_name)
      if @inventory.map(&:name).include?(item_name)
        @inventory.reject! { |item| item.name == item_name }
        puts "The #{item_name} has been thrown on the ground, but far out of reach, and you're much too lazy to go get it now, so it's as good as gone.\n"
      else
        ERROR_ITEM_REMOVE_INVALID
      end
    end
  end
end
