# lib/gemwarrior/entities/monsters/bosses/jaspern.rb
# Entity::Creature::Monster::Jaspern (BOSS)

require_relative '../../monster'
require_relative '../../items/tent'

module Gemwarrior
  class Jaspern < Monster
    def initialize
      super

      self.name         = 'jaspern'
      self.name_display = 'Jaspern'
      self.description  = 'Dark green hair, but yellow and brown skin, Jaspern is actually somewhat translucent, and he does not appear to be moveable or go-around-able.'
      self.battlecry    = 'I am the keeper of this bridge! To go further, you must get through me!'
      self.face         = 'crystalline'
      self.hands        = 'small'
      self.mood         = 'opaque'

      self.level        = rand(7..8)
      self.hp_cur       = rand((level * 4.5).floor..(level * 5.5).floor)
      self.hp_max       = hp_cur
      self.atk_lo       = rand((level * 2)..(level * 2.5).floor)
      self.atk_hi       = rand((level * 2.5).floor..(level * 3).floor)
      self.defense      = rand(5..7)
      self.dexterity    = rand(8..9)

      self.inventory    = random_item
      self.rox          = rand((level * 6)..(level * 7))
      self.xp           = rand((level * 8)..(level * 10))

      self.is_boss      = true
    end

    def river_bridge_success(world)
      # get object references
      river_bridge = world.location_by_name('river_bridge')
      jaspern = river_bridge.bosses_abounding[0]

      # mark jaspern as dead
      jaspern.is_dead = true
      jaspern.face        = 'broken'
      jaspern.hands       = 'limp'
      jaspern.mood        = 'defeated'
      jaspern.hp_cur      = 0
      jaspern.rox         = 0
      jaspern.description = 'As Jaspern lies motionless upon the ground, you feel sorry for murdering him in cold blood without any provocation, but you feel like he was probably bad, and you really needed to explore further north. Regardless, it looks like you own the bridge now.'
      jaspern.inventory   = Inventory.new

      # unlock northward travel
      river_bridge.description = 'The path northward on this well-constructed bridge is no longer blocked after your brutal scuffle with Jaspern, and yet the flowing river below seems unperturbed.'
      river_bridge.paths[:north] = true
      return
    end

    private

    def random_item
      if [true, false].sample
        Inventory.new(items = [Tent.new])
      else
        Inventory.new
      end
    end
  end
end