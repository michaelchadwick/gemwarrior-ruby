# lib/gemwarrior/misc/music.rb
# Music cues using win32-sound

module Gemwarrior
  module Music
    def self.cue(sequence)
      # if Windows, use superior win32-sound library
      if OS.windows?
        require 'win32/sound'
        threads = []

        Thread.start {
          sequence.each do |seq|
            seq[:frequencies].split(',').each do |note|
              threads << Thread.new {
                Win32::Sound::play_freq(Notes::NOTE_FREQ[note], seq[:duration], 0.5)
              }
            end
            threads.each { |th| th.join }
          end
        }
      # otherwise, use inferior feep library
      else
        require 'feep'
        require_relative 'musical_notes'

        feep_defaults = {
          :frequencies  => '440',
          :waveform     => 'sine',
          :volume       => 0.3,
          :duration     => 500,
          :notext       => true
        }
      
        Thread.start {
          sequence.each do |seq|
            seq = feep_defaults.merge(seq)

            Feep::Base.new({
              :freq_or_note => seq[:frequencies],
              :waveform     => seq[:waveform],
              :volume       => seq[:volume],
              :duration     => seq[:duration],
              :notext       => seq[:notext]
            })
          end
        }
      end
    end
  end
end
