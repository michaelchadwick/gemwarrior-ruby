# lib/gemwarrior/entities/items/tree.rb
# Entity::Item::Tree

require_relative '../item'

module Gemwarrior
  class Tree < Item
    def initialize
      super

      self.name         = 'tree'
      self.name_display = 'Tree'
      self.description  = 'A mighty representation of nature, older than your father\'s father\'s second great-uncle.'
    end
    
    def use(world)
      if self.used_again
        puts 'The tree, its trunk, and the hole in its side all seem fairly unremarkable to you now.'

        return { type: nil, data: nil }
      elsif self.used
        self.used_again = true
        
        puts 'Looking further into the small opening in the trunk your eye catches the light glinting off a few small metallic objects.'

        cur_loc = world.location_by_name('forest-southeast')
        cur_loc.items.push(Bullet.new)
        cur_loc.items.push(Bullet.new)
        cur_loc.items.push(Bullet.new)

        return { type: nil, data: nil }
      else
        self.used = true

        puts 'Taking a passing glance into the only hole in the tree big enough for anything to exist inside, you don\'t quite see anything of value.'

        { type: nil, data: nil }
      end
    end
  end
end
