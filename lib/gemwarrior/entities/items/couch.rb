# lib/gemwarrior/entities/items/couch.rb
# Entity::Item::Couch

require_relative '../item'

module Gemwarrior
  class Couch < Item
    def initialize
      super

      self.name         = 'couch'
      self.name_display = 'Couch'
      self.description  = 'Ever wanted to sit on a cloud? Now is your chance.'
    end

    def use(player = nil)
      if player.at_full_hp?
        puts 'You "sit" on the impossibly soft surface of the furniture, but even after a few minutes of this seemingly heavenly hedonism you don\'t feel significantly better and decide to get up again.'
        { type: nil, data: nil }
      else
        puts 'Your body comes to rest somewhere below the surface of the cloudy apparatus, almost as if it were floating *amongst* the couch. The feeling is heavenly, and you actually feel somewhat better after getting back up.'
        puts '>> You regain a few hit points.'.colorize(:green)
        { type: 'rest', data: 4 }
      end
    end
  end
end
