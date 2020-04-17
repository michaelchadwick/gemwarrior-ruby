class Rat
  attr_accessor :name,
                :level,
                :hp
  
  def initialize(name = 'rat')
    self.name   = name
    self.level  = rand(1..4)
    self.hp     = rand((self.level * 3)..(self.level * 5))
  end
end

m = [Rat.new]

rat_o = m[0]
rat_c = m[0].clone

puts "[initial]"
puts "m[0]  : #{m[0].inspect}"
puts "rat_o : #{rat_o.inspect}"
puts "rat_c : #{rat_c.inspect}"

m[0].hp -= 1

puts "[m[0] - 1hp]"
puts "m[0]  : #{m[0].inspect}"
puts "rat_o : #{rat_o.inspect}"
puts "rat_c : #{rat_c.inspect}"

rat_o.hp -= 1

puts "[rat_o - 1hp]"
puts "m[0]  : #{m[0].inspect}"
puts "rat_o : #{rat_o.inspect}"
puts "rat_c : #{rat_c.inspect}"

rat_c.hp -= 1

puts "[rat_c - 1hp]"
puts "m[0]  : #{m[0].inspect}"
puts "rat_o : #{rat_o.inspect}"
puts "rat_c : #{rat_c.inspect}"

rat_c2 = m[0].clone

puts "[rat_c2 created from m[0]]"
puts "m[0]  : #{m[0].inspect}"
puts "rat_o : #{rat_o.inspect}"
puts "rat_c : #{rat_c.inspect}"
puts "rat_c2: #{rat_c2.inspect}"
