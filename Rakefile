require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

task :deploy do |t|
<<<<<<< HEAD
  file = Dir.glob("pkg/*").max_by {|f| File.mtime(f)}

  sh "git push origin master"
  sh "rake build"
  sh "gem push #{file}"
=======
  file = sh "ls -t -1 pkg/ | sed '1q'"

  sh "git push origin master"
  sh "rake build"
  sh "gem push pkg/#{file}"
>>>>>>> ae3633371a323c5b8f0fdaf0671014ce95685039
end

task :default => :spec
