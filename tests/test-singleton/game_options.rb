module GameOptions
  def self.add key, value
    @@data ||= {}
    @@data[key] = value
  end

  def self.data
    @@data ||= {}
  end
end

GameOptions.data

GameOptions.add 'sound_enabled', true
GameOptions.add 'sound_volume', 0.3
