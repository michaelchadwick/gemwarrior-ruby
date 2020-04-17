new_release_available = false

puts 'Checking releases...'

remote_release = '0.10.3'
local_release = '0.10.3'

0.upto(2) do |i|
  if remote_release.split('.')[i].to_i > local_release.split('.')[i].to_i
    new_release_available = true
  end
end

status_text = new_release_available ? "New v#{remote_release} available!" : 'You have the latest version.'

puts "local_release: #{local_release}"
puts "remote_release #{remote_release}"
puts status_text