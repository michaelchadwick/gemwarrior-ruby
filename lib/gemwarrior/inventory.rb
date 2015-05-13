# lib/gemwarrior/inventory.rb
# Collection of items a creature possesses

module Gemwarrior
  class Inventory
    def initialize
      @inventory = []
    end
    
    def list
      if @inventory.empty?
        puts "...and find you currently have diddly-squat, which is nothing.\n"
      else
        puts ": #{@inventory.join ', '}"
      end
    end
    
    def add_item(item)
      @inventory.push(item)
      puts "Added #{item} to your increasing collection of bits of tid.\n"
    end
    
    def remove_item(item)
      @inventory.delete(item)
      puts "#{item} has been thrown on the ground, but far out of reach, and you're much too lazy to go get it now, so it's as good as gone.\n"
    end
  end
end