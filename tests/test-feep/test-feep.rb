require 'feep'

sequence = [
  {freq_or_note: 'A3', duration: 80},
  {freq_or_note: 'E4', duration: 80},
  {freq_or_note: 'G4', duration: 80},
  {freq_or_note: 'C#5', duration: 80},
  {freq_or_note: 'G5', duration: 240}
]

defaults = {
  :freq_or_note => '440', 
  :waveform     => 'saw', 
  :volume       => 0.3, 
  :duration     => 100,
  :notext       => true
}

sequence.each do |seq|
  puts "seq before merge: #{seq}"
  
  seq = defaults.merge(seq)
  
  puts "seq after merge: #{seq}"

  puts "playing #{seq[:freq_or_note]}"
  
  Feep::Base.new({
    :freq_or_note => seq[:freq_or_note], 
    :waveform     => seq[:waveform], 
    :volume       => seq[:volume], 
    :duration     => seq[:duration],
    :notext       => seq[:notext]
  })
end