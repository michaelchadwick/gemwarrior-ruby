# lib/gemwarrior/entities/boss.rb
# Boss monster

require_relative 'monster'

module Gemwarrior
  class Boss < Monster
    attr_reader :win_text

    def win_text
      win_text =  'You beat #{name}! You win! '
      win_text << 'You become the true Gem Warrior, marry Queen Ruby, and have many fine, sparkling children. '
      win_text << 'Thank you for playing. Goodbye.'
      puts win_text
      exit(0)
    end
  end
end
