module AudioCues
  def self.add key, val
    @@cues ||= {}
    @@cues[key] = val
  end
  
  def self.cues
    @@cues ||= {}
  end

  self.add :battle_start, {
    synth: [
      { frequencies: 'G4',  duration: 50 },
      { frequencies: 'G#4', duration: 50 },
      { frequencies: 'G4',  duration: 50 },
      { frequencies: 'G#4', duration: 50 },
      { frequencies: 'G4',  duration: 50 },
      { frequencies: 'G#4', duration: 50 }
    ],
    sample: 'battle_start.wav'
  }

  self.add :battle_player_attack, {
    synth: [{ frequencies: 'A4,E4,B5', duration: 75 }],
    sample: 'battle_player_attack.wav'
  }

  self.add :battle_player_miss, {
    synth: [{ frequencies: 'A4', duration: 75 }],
    sample: 'battle_player_miss.wav'
  }

  self.add :battle_monster_attack, {
    synth: [{ frequencies: 'B4,E#5,A5', duration: 75 }],
    sample: 'battle_monster_attack.wav'
  }

  self.add :battle_monster_miss, {
    synth: [{ frequencies: 'B4', duration: 75 }],
    sample: 'battle_monster_miss.wav'
  }

  self.add :intro, {
    synth: [
      { frequencies: 'A3,E4,C#5,E5',  duration: 300 },
      { frequencies: 'A3,E4,C#5,F#5', duration: 600 }
    ],
    sample: 'intro.wav'
  }

  self.add :player_resurrection, {
    synth: [
      { frequencies: 'D#5', duration: 100 },
      { frequencies: 'A4',  duration: 150 },
      { frequencies: 'F#4', duration: 200 },
      { frequencies: 'F4',  duration: 1000 }
    ],
    sample: 'player_resurrection.wav'
  }

  self.add :player_travel, {
    synth: [
      { frequencies: 'C4', duration: 75 },
      { frequencies: 'D4', duration: 75 },
      { frequencies: 'E4', duration: 75 }
    ],
    sample: 'player_travel.wav'
  }

  self.add :win_game, {
    synth: [
      { frequencies: 'G3',  duration: 250 },
      { frequencies: 'A3',  duration: 50 },
      { frequencies: 'B3',  duration: 50 },
      { frequencies: 'C4',  duration: 50 },
      { frequencies: 'D4',  duration: 250 },
      { frequencies: 'E4',  duration: 50 },
      { frequencies: 'F#4', duration: 50 },
      { frequencies: 'G4',  duration: 50 },
      { frequencies: 'A4',  duration: 250 },
      { frequencies: 'B4',  duration: 50 },
      { frequencies: 'C5',  duration: 50 },
      { frequencies: 'D5',  duration: 50 },
      { frequencies: 'E5',  duration: 50 },
      { frequencies: 'F#5', duration: 50 },
      { frequencies: 'G5',  duration: 1000 }
    ],
    sample: 'win_game.wav'
  }
end
