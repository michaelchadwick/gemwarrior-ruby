# lib/gemwarrior/misc/bloops_cues.rb
# Bloops cue symbol -> notes/wav_file

module Gemwarrior
  module BloopsCues
    def self.add key, val
      @@cues ||= {}
      @@cues[key] = val
    end

    def self.cues
      @@cues ||= {}
    end

    self.add :bg1, {
      synth: [
        { s1: '2:C4' },
        { s1: '2:C5' },
        { s1: '2:C4' },
        { s1: '2:C5' },
        { s1: '2:C4' },
        { s1: '2:C5' },
        { s1: '2:G4' },
        { s1: '2:A4' },
        { s1: '2:C4' },
        { s1: '2:C5' },
        { s1: '2:C4' },
        { s1: '2:C5' },
        { s1: '2:C4' },
        { s1: '2:C5' },
        { s1: '2:B4' },
        { s1: '2:A4' },
      ],
      sample: 'bg1.wav'
    }

    self.add :battle_start, {
      synth: [
        { s1: '16:G4' },
        { s1: '16:G#4' },
        { s1: '16:G4' },
        { s1: '16:G#4' },
        { s1: '16:G4' },
        { s1: '16:G#4' }
      ],
      sample: 'battle_start.wav'
    }

    self.add :battle_player_attack, {
      synth: [{ s1: '16:A4', s2: '16:E4', s3: '16:B5' }],
      sample: 'battle_player_attack.wav'
    }

    self.add :battle_player_miss, {
      synth: [{ s1: '8:A4' }],
      sample: 'battle_player_miss.wav'
    }

    self.add :battle_monster_attack, {
      synth: [{ s1: '16:B4', s2: '16:E#5', s3: '16:A5' }],
      sample: 'battle_monster_attack.wav'
    }

    self.add :battle_monster_miss, {
      synth: [{ s1: '8:B4' }],
      sample: 'battle_monster_miss.wav'
    }

    self.add :battle_win_boss, {
      synth: [
        { s1: '16:E5' },
        { s1: '16:F5' },
        { s1: '8:E5' },
        { s1: '16:E5' },
        { s1: '16:F5' },
        { s1: '8:E5' },
        { s1: '16:E4', s2: '16:A4' },
        { s1: '4:E4',  s2: '4:A4' }
      ],
      sample: 'battle_win_boss.wav'
    }

    self.add :battle_win_monster, {
      synth: [
        { s1: '16:D5' },
        { s1: '16:E5' },
        { s1: '8:D5' },
        { s1: '16:D4' },
        { s1: '4:D4' }
      ],
      sample: 'battle_win_monster.wav'
    }

    self.add :intro, {
      synth: [
        { s1: '16:C3', s2: '16:G4' },
        { s1: '16:D3', s2: '16:A4' },
        { s1: '16:E3', s2: '16:B4' },
        { s1: '16:F3', s2: '16:C5' },
        { s1: '4:G3', s2: '4:B4', s3: '4:D5' }
      ],
      sample: 'intro.wav'
    }

    self.add :player_level_up, {
      synth: [
        { s1: '8:D4', s2: '8:A4', s3: '8:D5', s4: '8:A5', s5: '8:D6' },
        { s1: '4:D4', s2: '4:A4', s3: '4:D5', s4: '4:A5', s5: '4:D6' },
        { s1: '1:E4', s2: '1:B4', s3: '1:E5', s4: '1:B5', s5: '1:E6' }
      ]
    }

    self.add :player_resurrection, {
      synth: [
        { s1: '16:D#5' },
        { s1: '14:A4' },
        { s1: '12:F#4' },
        { s1: '2:F4' }
      ],
      sample: 'player_resurrection.wav'
    }

    self.add :player_travel, {
      synth: [
        { s1: '16:C4' },
        { s1: '16:D4' },
        { s1: '16:E4' }
      ],
      sample: 'player_travel.wav'
    }

    self.add :player_travel_east, {
      synth: [
        { s1: '16:E4' },
        { s1: '16:G4' },
        { s1: '16:E4' }
      ],
      sample: 'player_travel_east.wav'
    }

    self.add :player_travel_north, {
      synth: [
        { s1: '16:C4' },
        { s1: '16:D4' },
        { s1: '16:E4' }
      ],
      sample: 'player_travel_north.wav'
    }

    self.add :player_travel_south, {
      synth: [
        { s1: '16:E4' },
        { s1: '16:D4' },
        { s1: '16:C4' }
      ],
      sample: 'player_travel_south.wav'
    }

    self.add :player_travel_west, {
      synth: [
        { s1: '16:C4' },
        { s1: '16:A4' },
        { s1: '16:C4' }
      ],
      sample: 'player_travel_west.wav'
    }

    self.add :test, {
      synth: [
        { s1: '4:F4' },
        { s1: '4:E5' },
        { s1: '4:C5' },
        { s1: '4:E5' }
      ],
      sample: 'test.wav'
    }

    self.add :uncover_secret, {
      synth: [
        { s1: '8:F5' },
        { s1: '8:E5' },
        { s1: '8:C#4' },
        { s1: '8:C4' },
        { s1: '8:D#5' },
        { s1: '8:F#5' },
        { s1: '8:A5' }
      ],
      sample: 'uncover_secret.wav'
    }

    self.add :win_game, {
      synth: [
        { s1: '4:G3' },
        { s1: '16:A3' },
        { s1: '16:B3' },
        { s1: '16:C4' },
        { s1: '4:D4' },
        { s1: '16:E4' },
        { s1: '16:F#4' },
        { s1: '16:G4' },
        { s1: '4:A4' },
        { s1: '16:B4' },
        { s1: '16:C5' },
        { s1: '16:D5' },
        { s1: '16:E5' },
        { s1: '16:F#5' },
        { s1: '1:G5' }
      ],
      sample: 'win_game.wav'
    }
  end
end
