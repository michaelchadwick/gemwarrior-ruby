# lib/gemwarrior/misc/music.rb
# Music cue

require 'win32/sound'
include Win32

require_relative 'musical_notes'

module Gemwarrior
  module Music  
    def self.cue(sequence)
      if OS.windows?
        threads = []

        Thread.start {
          sequence.each do |seq|
            seq[:frequencies].split(',').each do |note|
              threads << Thread.new {
                Sound::play_freq(Notes::NOTE_FREQ[note], seq[:duration], 0.1)
              }
            end
            threads.each { |th| th.join }
          end
        }
      end
    end
  end
end
