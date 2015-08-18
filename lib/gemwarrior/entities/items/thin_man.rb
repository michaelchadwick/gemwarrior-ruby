# lib/gemwarrior/entities/items/thin_man.rb
# Item::ThinMan

require_relative '../item'

module Gemwarrior
  class ThinMan < Item
    def initialize
      super

      self.name         = 'thin_man'
      self.description  = 'An almost shockingly gaunt man is sitting on the ground, resting against a wall. He wears a patchwork quilt of a hat, and his slender frame is covered by a simple brown tunic. His feet point comically toward the sky in brown boots while his head dips down slightly, eyes watching something in the distance you can\'t see.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = false
      self.useable      = true
      self.equippable   = false
      self.talkable     = true
    end

    def use(player = nil)
      if self.used
        puts 'The thin man barely moves his head as he puts up a single grim hand, motioning you to back off.'
      else
        puts 'The thin man lifts his head up slightly, meets your gaze, and responds to your greeting:'
        puts '>> "I may be incredibly spare right now, but I was once a strapping young person, such as yourself. Just in case you ever fall during your journey, be sure to approach unlikely sources, as you may find those who will help you."'
        puts '>> "Now, please, allow me my peace."'

        self.used = true
      end
      
      { type: nil, data: nil }
    end
  end
end
