require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

task :deploy do |t|
  sh "git push origin master"
  sh "rake build"

  file = Dir.glob("pkg/*").max_by {|f| File.mtime(f)}

  sh "gem push #{file}"
end

task :default => :spec
