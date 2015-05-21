# lib/gemwarrior/creature.rb
# Creature base class

require_relative 'inventory'

module Gemwarrior
  class Creature
    # CONSTANTS
    CREATURE_NAME_DEFAULT          = 'Creature'
    CREATURE_DESCRIPTION_DEFAULT   = 'A creature of some sort.'
    CREATURE_FACE_DEFAULT          = 'calm'
    CREATURE_HANDS_DEFAULT         = 'smooth'
    CREATURE_MOOD_DEFAULT          = 'happy'

    attr_accessor :id, :name, :description, :face, :hands, :mood, 
                  :level, :hp_cur, :hp_max, :inventory
    
    def initialize(
      id, 
      name = CREATURE_NAME_DEFAULT,
      description = CREATURE_DESCRIPTION_DEFAULT, 
      face = CREATURE_FACE_DEFAULT, 
      hands = CREATURE_HANDS_DEFAULT, 
      mood = CREATURE_MOOD_DEFAULT, 
      level = 1, 
      hp_cur = 10, 
      hp_max = 10, 
      inventory = Inventory.new
    )
      self.id = id
      self.name = name
      self.description = description
      self.face = face
      self.hands = hands
      self.mood = mood

      self.level = level
      self.hp_cur = hp_cur
      self.hp_max = hp_max

      self.inventory = inventory
    end
    
    def describe
      self.description
    end
    
    def status
      status_text =  "[#{name}][LVL: #{level}][HP:#{hp_cur}|#{hp_max}]\n"
      status_text << "Its face is #{face}, hands are #{hands}, and general mood is #{mood}."
    end
  end
end
