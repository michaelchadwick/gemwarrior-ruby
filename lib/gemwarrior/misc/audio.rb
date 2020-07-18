# lib/gemwarrior/misc/audio.rb
# Audio cues using either synth or samples
# Synth: win32-sound, feep, or bloopsaphone depending on platform/choice
# Samples: small wav files

require_relative '../game_options'

module Gemwarrior
  module Audio
    def self.init
      if GameOptions.data['sound_system'].eql?('win32-sound')
        begin
          require 'win32/sound'
        rescue
          GameOptions.data['errors'] = "#{GameOptions.data['sound_system']} could not be loaded. You may need to run 'gem install #{GameOptions.data['sound_system']}'. Silence for now."
        end
      elsif GameOptions.data['sound_system'].eql?('feep')
        begin
          require 'feep'
        rescue
          GameOptions.data['errors'] = "#{GameOptions.data['sound_system']} could not be loaded. You may need to run 'gem install #{GameOptions.data['sound_system']}'. Silence for now."
        end
      elsif GameOptions.data['sound_system'].eql?('bloops')
        begin
          require 'bloops'
        rescue
          GameOptions.data['errors'] = "#{GameOptions.data['sound_system']} could not be loaded. You may need to run 'gem install #{GameOptions.data['sound_system']}aphone'. Silence for now."
        end
      end
    end

    def self.play_synth(audio_cue_symbol)
      if GameOptions.data['sound_enabled']
        case GameOptions.data['sound_system']
        when 'win32-sound'
          require_relative 'audio_cues'
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
        when 'feep'
          require_relative 'audio_cues'
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
        when 'bloops'
          require_relative 'bloops_cues'
          Thread.start do
            BloopsCues.cues[audio_cue_symbol][:synth].each do |seq|
              threads = []

              seq.each do |note|
                threads << Thread.new do
                  b = Bloops.new
                  b.tempo = 240
                  snd = b.sound Bloops::SQUARE
                  snd.punch = GameOptions.data['sound_volume']/2
                  snd.sustain = 0.7
                  snd.decay = 0.2
                  b.tune snd, note[1]
                  b.play
                  sleep 0.1 while !b.stopped?
                end
              end

              threads.each { |th| th.join }
            end
          end
        end
      end
    end

    def self.play_sample(audio_cue_symbol)
      # future use
    end
  end
end
