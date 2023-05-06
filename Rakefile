require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

task :deploy do |t|
  file = sh "ls -t -1 pkg/ | sed '1q'"

  sh "git push origin master"
  sh "rake build"
  sh "gem push pkg/#{file}"
end

task :default => :spec
