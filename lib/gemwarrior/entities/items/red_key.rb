# lib/gemwarrior/entities/items/red_key.rb
# Entity::Item::RedKey

require_relative '../item'

module Gemwarrior
  class RedKey < Item
    attr_accessor :locked

    def initialize
      super

      self.name         = 'red_key'
      self.name_display = 'Red Key'
      self.description  = 'Redder than an embarrassed tomato in front of a moderate fire, but still very capable of being a key.'
    end

    def describe(world)
      super

      cur_location = world.location_by_coords(world.player.cur_coords)
      if cur_location.name.eql?('pain_quarry-west')
        return desc_text += ' The key "glows" quite intently.'.colorize(:red)
      elsif cur_location.name.include?('pain_quarry')
        return desc_text += ' The key "glows" almost so brightly you have to shield your eyes.'.colorize(:red)
      else
        return desc_text += ' The key lightly "glows".'.colorize(:red)
      end
    end

    def describe_detailed(world)
      desc_text =  "\"#{name_display}\"\n".colorize(:yellow)
      desc_text << "(#{name})\n".colorize(:green)
      desc_text << "#{description}\n".colorize(:white)

      cur_location = world.location_by_coords(world.player.cur_coords)
      if cur_location.name.include?('pain_quarry')
        desc_text += "The key O==> *glows* quite intently.\n".colorize(:red)
      elsif cur_location.name.eql?('pain_quarry-west')
        desc_text += "The key O==> *shines* almost so brightly you have to shield your eyes.\n".colorize(:red)
      else
        desc_text += "The key O==> lightly *shimmers*.\n".colorize(:red)
      end

      desc_text << "TAKEABLE?   #{takeable}\n".colorize(:white)
      desc_text << "USEABLE?    #{useable}\n".colorize(:white)
      desc_text << "TALKABLE?   #{talkable}\n".colorize(:white)
      desc_text << "CONSUMABLE? #{consumable}\n".colorize(:white)
      desc_text << "EQUIPPABLE? #{equippable}\n".colorize(:white)
      desc_text << "EQUIPPED?   #{equipped}\n".colorize(:white)
      desc_text << "USED?       #{used}\n".colorize(:white)
      desc_text << "USED AGAIN? #{used_again}\n".colorize(:white)
      desc_text << "USES LEFT?  #{number_of_uses}\n".colorize(:white) unless number_of_uses.nil?
      desc_text
    end

    def use(world)
      cur_location = world.location_by_coords(world.player.cur_coords)

      if cur_location.contains_item?('locker')
        locker = cur_location.get_item_ref('locker')
        if locker.locked
          puts 'You place the reddish key into the lock on the locker. Moments later, after a quick turn, the locked locker is no longer locked.'

          locker.locked = false
          locker.description = 'A small, unlocked locker with a lock on it. You have unlocked it with a reddish key you found.'
          { type: nil, data: nil }
        else
          puts 'You place the reddish key into the lock on the locker. Moments later, after a quick turn, the locked locker is once again quite locked.'
          
          locker.locked = true
          locker.description = 'A small, locked locker with a lock on it. You will need to unlock it to gain access to its insides.'
          { type: nil, data: nil }
        end
      else
        puts 'You try to put the key into one of its natural habitats, but can\'t find anything suitable.'

        { type: nil, data: nil }
      end
    end
  end
end
