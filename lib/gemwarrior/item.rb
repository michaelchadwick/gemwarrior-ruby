# lib/gemwarrior/item.rb
# Item base class

module Gemwarrior
  class Item
    attr_accessor :id, :name, :description, 
                  :atk_lo, :atk_hi, :takeable, :equippable, :equipped
    
    def initialize(
      id, 
      name, 
      description,
      atk_lo,
      atk_hi,
      takeable,
      equippable, 
      equipped = false
    )
      self.id = id
      self.name = name
      self.description = description
      self.atk_lo = atk_lo
      self.atk_hi = atk_hi
      self.takeable = takeable
      self.equippable = equippable
      self.equipped = equipped
    end
    
    def status
      status_text =  name.ljust(20).upcase
      status_text << "#{description}\n"
      status_text.to_s
    end
  end
end
