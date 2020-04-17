require 'io/console'

puts 'press a key using STDIN.getc'
c = STDIN.getc
puts "c: #{c.dump}"

puts 'press another key using STDIN.getch'
ch = STDIN.getch
puts "ch: #{ch.dump}"
