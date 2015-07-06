# lib/gemwarrior/misc/music.rb
# Music cue

module Gemwarrior
  module Music
    def self.cue(sequence)
      defaults = {
        :freq_or_note => 440, 
        :waveform     => 'saw', 
        :volume       => 0.3, 
        :duration     => 500,
        :notext       => true
      }

      Thread.start {
        sequence.each do |note|
          note_to_play  = note[:freq_or_note]
          waveform      = note[:waveform].nil? ? defaults[:waveform] : note[:waveform]
          volume        = note[:volume].nil? ? defaults[:volume] : note[:volume]
          duration      = note[:duration].nil? ? defaults[:duration] : note[:duration]
          notext        = note[:notext].nil? ? defaults[:notext] : note[:notext]

          Feep::Base.new({
            :freq_or_note => note_to_play, 
            :waveform     => waveform, 
            :volume       => volume, 
            :duration     => duration,
            :notext       => notext
          })
        end
      }
    end
  end
end
