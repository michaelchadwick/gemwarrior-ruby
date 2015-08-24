# lib/gemwarrior/game_assets.rb
# Gem Warrior Global Assets
## Game Armor
## Game Creatures
## Game Items
## Game Monsters
## Game People
## Game Weapons

module Gemwarrior
  module GameArmor
    def self.add obj
      @@data ||= []
      @@data.push(obj)
    end

    def self.data
      @@data ||= []
    end
  end
  
  module GameCreatures
    def self.add obj
      @@data ||= []
      @@data.push(obj)
    end

    def self.data
      @@data ||= []
    end
  end
  
  module GameItems
    def self.add obj
      @@data ||= []
      @@data.push(obj)
    end

    def self.data
      @@data ||= []
    end
  end
  
  module GameMonsters
    def self.add obj
      @@data ||= []
      @@data.push(obj)
    end

    def self.data
      @@data ||= []
    end
  end
  
  module GamePeople
    def self.add obj
      @@data ||= []
      @@data.push(obj)
    end

    def self.data
      @@data ||= []
    end
  end
  
  module GameWeapons
    def self.add obj
      @@data ||= []
      @@data.push(obj)
    end

    def self.data
      @@data ||= []
    end
  end
end
