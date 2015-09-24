# lib/gemwarrior/entities/items/chest.rb
# Entity::Item::Chest

require_relative '../item'

module Gemwarrior
  class Chest < Item
    def initialize
      super

      self.name         = 'chest'
      self.name_display = 'Chest'
      self.description  = 'Well-crafted with solid oak, this family chest has intricate inlays all around the front and sides. It\'s the one thing from home you took with you when you left.'
    end

    def use(world)
      home = world.location_by_name('home')
      open_description = 'You open the chest and find little inside but some dust and faded memories of your childhood.'

      if self.used
        if home.contains_item?('leather_jerkin')
          open_description += ' The old sword fighting garment is still in there, too.'
        end
        puts open_description

        { type: nil, data: nil }
      else
        open_description += ' That, and a slightly dirty, but still useful garment you remember using while taking those sword fighting lessons as a small boy.'

        puts open_description

        home.items.push(LeatherJerkin.new)

        self.used = true

        { type: nil, data: nil }
      end
    end
  end
end
