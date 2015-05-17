# lib/gemwarrior/inventory.rb
# Collection of items a creature possesses

module Gemwarrior
  class Inventory
    include Errors
    
    def initialize(inventory = [])
      @inventory = inventory
    end
    
    def list_contents
      print 'You check your inventory'
      if @inventory.empty?
        print ERROR_INVENTORY_EMPTY
      else
        @item_names = []
        @inventory.each do |i|
          @item_names.push(i.name)
        end
        print ": #{@item_names.join ', '}"
      end
    end
    
    def describe_item(item_name)
      @item_names = []
      @inventory.each do |i|
        @item_names.push(i.name)
      end

      if @item_names.include?(item_name)
        @inventory.each do |i|
          if i.name.eql?(item_name)
            puts "#{i.description}"
            return
          end
        end
      else
        puts ERROR_ITEM_INVALID
      end
    end
        
    def add_item(items, item_name)
      item_added = false
      items.each do |i|
        if i.name.eql?(item_name)
          if i.takeable
            @inventory.push(i)
            item_added = true
            puts "Added #{item_name} to your increasing collection of bits of tid.\n"
            return item_added
          else
            puts ERROR_TAKE_ITEM_UNTAKEABLE
            return
          end
        end
      end
      puts ERROR_TAKE_ITEM_INVALID
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
