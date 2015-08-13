# lib/gemwarrior/misc/music.rb
# Music cues using win32-sound or feep, depending on platform

require_relative '../game_options'

module Gemwarrior
  module Music
    def self.cue(sequence)
      if GameOptions.data['sound_enabled']
        # if Windows, use superior win32-sound library
        if OS.windows?
          require 'win32/sound'
          require_relative 'musical_notes'
        
          Thread.start do
            sequence.each do |seq|
              threads = []
              seq[:frequencies].split(',').each do |note|
                threads << Thread.new do
                  Win32::Sound::play_freq(Notes::NOTE_FREQ[note], seq[:duration], GameOptions.data['sound_volume'])
                end
              end
              threads.each { |th| th.join }
            end
          end
        # otherwise, use inferior feep library
        else
          require 'feep'

          feep_defaults = {
            frequencies:  '440',
            waveform:     'sine',
            volume:       GameOptions.data['sound_volume'],
            duration:     500,
            notext:       true
          }
      
          Thread.start do
            sequence.each do |seq|
              seq = feep_defaults.merge(seq)

              Feep::Base.new({
                freq_or_note: seq[:frequencies],
                waveform:     seq[:waveform],
                volume:       seq[:volume],
                duration:     seq[:duration],
                notext:       seq[:notext]
              })
            end
          end
        end
      end
    end
  end
end
