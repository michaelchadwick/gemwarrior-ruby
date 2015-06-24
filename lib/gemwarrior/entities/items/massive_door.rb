# lib/gemwarrior/entities/items/massive_door.rb
# Item::MassiveDoor

require_relative '../item'

module Gemwarrior
  class MassiveDoor < Item
    def initialize
      self.name         = 'massive_door'
      self.description  = 'Translucent, but not transparent, this door constructed of condensed water vapor is like nothing you have ever seen. It has no keyhole, but it does have a stone-shaped depression floating centrally within it.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end
    
    def use(player = nil)
      puts 'You attempt to open the seriously massive door that separates you from Emerald himself.'
      if player.inventory.has_item?('keystone')
        puts 'The keystone in your inventory glows as you approach the incredibly titanic-sized door, so you naturally pull it out and thrust it into the stone-shaped depression within the cloudy obstruction. The door "opens" in a way and you can now pass through.'
        {:type => 'move', :data => 'Sky Tower (Throne Room)'}
      else
        puts 'Your hand just goes right through the astonishingly gigantic door, but the rest of your body does not. A moment later, your hand is shoved backwards by some unknown force, and you remain where you were before your unsuccessful attempt.'
        {:type => nil, :data => nil}
      end
    end
  end
end
