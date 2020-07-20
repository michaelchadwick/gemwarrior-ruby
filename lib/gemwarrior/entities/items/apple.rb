# lib/gemwarrior/entities/items/apple.rb
# Entity::Item::Apple

require_relative '../item'

module Gemwarrior
  class Apple < Item
    def initialize
      super

      self.name         = 'apple'
      self.name_display = 'Apple'
      self.description  = 'Reddish-orangeish in color, this fruit looks sweet, but it is heavy and feels more like a rock you would sooner not bite into.'
      self.takeable     = true
    end

    def use(world)
      if !self.used
        puts 'You attempt to consume the apple, but stop midway through your first bite. Something tells you this is not a good idea, and you stop.'
        puts
        self.used = true
      else
        puts 'Remembering the odd feeling you got the last time you attempted to use the apple, you refrain.'
        { type: nil, data: nil }
      end
    end
  end
end
