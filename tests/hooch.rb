s = 'I still can\'t believe I lost at the Arena! I was doing so well, and then a slippery citrinaga got a cheap shot on me.'
words = s.split(' ')
words_hooched = []

words.each do |w|
  puts "w: #{w}"
  if rand(0..100) > 45 and w.length > 1
    w = w.split('')
    w = w.insert(rand(0..w.length-1), '*HIC*')
    w = w.join('')
  end
  words_hooched << w
end

puts
puts "Final sentence: #{words_hooched.join(' ')}"
