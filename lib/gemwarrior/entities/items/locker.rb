# lib/gemwarrior/entities/items/locker.rb
# Entity::Item::Locker

require_relative '../item'

module Gemwarrior
  class Locker < Item
    attr_accessor :locked
  
    def initialize
      super

      self.name         = 'locker'
      self.name_display = 'Locker'
      self.description  = 'A small, locked locker with a lock on it. You will need to unlock it to gain access to its insides.'
      self.takeable     = false
      self.locked       = true
    end

    def use(world)
      cur_location = world.location_by_coords(world.player.cur_coords)
      locker = cur_location.get_item_ref('locker')

      if locker.locked
        puts 'You pull on the lock, hoping it will unlock and leave the locker unlocked, but it is no good. You will need something else to unlock this locked locker.'

        return { type: nil, data: nil }
      else
        if self.used
          puts 'The locker is open and you can see a shiny gem inside.'

          return { type: nil, data: nil }
        else
          self.used = true
          puts 'You open the unlocked locker and look inside. Thereabouts, is a shiny gem of some sort.'
          cur_location.add_item('sand_jewel')

          return { type: nil, data: nil }
        end
      end
    end
  end
end
