# lib/gemwarrior/entities/items/tower_switch.rb
# Item::TowerSwitch

require_relative '../item'

module Gemwarrior
  class TowerSwitch < Item
    def initialize
      self.name         = 'tower_switch'
      self.description  = 'A pedestal about 4 feet in height rises up from the ground, a switch atop it. It is labeled "Tower" and the choices are "Yes" and "No". It is currently set to "No".'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.equipped     = false
    end
    
    def use
      puts 'You move the switch from "No" to "Yes". Suddenly, a great wind picks up and you are gently lifted up by it. The ground moves away and your whole body begins to gently drift towards Emerald\'s compound high in the stratosphere.'
      puts

      t = Thread.new do
        print "#{Matrext::process({ :phrase => '*** WHOOOOOSH ***', :oneline => true })}"
        puts
      end
      t.join

      {:type => 'move', :data => 'Sky Tower (Foyer)'}
    end
  end
end