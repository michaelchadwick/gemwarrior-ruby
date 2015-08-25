# lib/gemwarrior/misc/audio.rb
# Audio cues using either synth or samples
# Synth: win32-sound or feep, depending on platform
# Samples: small wav files

require_relative '../game_options'
require_relative 'audio_cues'
require_relative 'musical_notes'

module Gemwarrior
  module Audio
    def self.play_sample(audio_cue_symbol)
      # future use
    end

    def self.play_synth(audio_cue_symbol)
      if GameOptions.data['sound_enabled']
        # if Windows, use superior win32-sound library
        if GameOptions.data['sound_system'].eql?('win32-sound')
          require 'win32/sound'
          require_relative 'musical_notes'

          Thread.start do
            AudioCues.cues[audio_cue_symbol][:synth].each do |seq|
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
        elsif GameOptions.data['sound_system'].eql?('feep')
          require 'feep'

          feep_defaults = {
            frequencies:  '440',
            waveform:     'sine',
            volume:       GameOptions.data['sound_volume'],
            duration:     500,
            notext:       true
          }
      
          Thread.start do
            AudioCues.cues[audio_cue_symbol][:synth].each do |seq|
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
