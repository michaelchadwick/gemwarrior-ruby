# lib/gemwarrior/misc/audio.rb
# Audio cues using either synth or samples
# Synth: win32-sound, feep, or bloopsaphone depending on platform/choice
# Samples: small wav files

require_relative '../game_options'

module Gemwarrior
  module Audio
    # CONSTANTS
    ERROR_SOUND_NOT_ENABLED       = 'Sound is disabled! Enable in main options to hear sound.'
    ERROR_SOUND_SYSTEM_NOT_CHOSEN = 'Sound system not chosen! Choose one in main options to hear sound.'
    ERROR_BLOOPS_NOT_FOUND        = 'bloopsaphone gem not found. Try \'gem install bloopsaphone\'.'
    ERROR_FEEP_NOT_FOUND          = 'feep gem not found. Try \'gem install feep\'.'
    ERROR_WIN32_NOT_FOUND         = 'win32-sound gem not found. Try \'gem install win32-sound\'.'

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
      else
        GameOptions.data['errors'] = "'#{GameOptions.data['sound_system']}' is not a valid sound system. Audio subsystem load failed."
      end
    end

    def self.get_cues
      if GameOptions.data['sound_enabled']
        case GameOptions.data['sound_system']
        when 'win32-sound', 'feep'
          require_relative 'audio_cues'
          AudioCues.cues
        when 'bloops'
          require_relative 'bloops_cues'
          BloopsCues.cues
        end
      end
    end

    def self.play_synth(audio_cue_symbol)
      if GameOptions.data['sound_enabled']
        if GameOptions.data['sound_system']
          case GameOptions.data['sound_system']
          when 'win32-sound'
            if system('gem list -ie win32-sound')
              require_relative 'audio_cues'
              require_relative 'musical_notes'

              if AudioCues.cues[audio_cue_symbol]
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
              end
            else
              GameOptions.data['errors'] = ERROR_WIN32_NOT_FOUND
            end
          when 'feep'
            if system('gem list -ie feep')
              require_relative 'audio_cues'

              feep_defaults = {
                frequencies:  '440',
                waveform:     'sine',
                volume:       GameOptions.data['sound_volume'],
                duration:     500,
                notext:       true
              }

              if AudioCues.cues[audio_cue_symbol]
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
            else
              GameOptions.data['errors'] = ERROR_FEEP_NOT_FOUND
            end
          when 'bloops'
            if system('gem list -ie bloops')
              require_relative 'bloops_cues'

              if BloopsCues.cues[audio_cue_symbol]
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
            else
              GameOptions.data['errors'] = ERROR_BLOOPS_NOT_FOUND
            end
          end
        else
          GameOptions.data['errors'] = ERROR_SOUND_SYSTEM_NOT_CHOSEN
        end
      else
        GameOptions.data['errors'] = ERROR_SOUND_NOT_ENABLED
      end
    end

    def self.play_sample(audio_cue_symbol)
      # future use
    end
  end
end
