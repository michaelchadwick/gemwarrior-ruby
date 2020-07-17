# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gemwarrior/version'

Gem::Specification.new do |spec|
  spec.name            = 'gemwarrior'
  spec.version         = Gemwarrior::VERSION
  spec.platform        = Gem::Platform::RUBY
  spec.authors         = ['Michael Chadwick']
  spec.email           = 'mike@codana.me'
  spec.homepage        = 'http://rubygems.org/gems/gemwarrior'
  spec.summary         = 'RubyGem text adventure'
  spec.description     = 'A fun text adventure in the form of a RubyGem!'

  spec.files           = `git ls-files`.split("\n")
  spec.test_files      = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables     = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths   = ['lib']
  spec.license         = 'MIT'

  spec.add_runtime_dependency 'os', '~> 0.9', '>= 0.9.6'
  spec.add_runtime_dependency 'http', '~> 0.8.10'
  spec.add_runtime_dependency 'json', '~> 1.8.2'
  spec.add_runtime_dependency 'colorize', '~> 0.7.7'
  spec.add_runtime_dependency 'matrext', '~> 1'
  spec.add_runtime_dependency 'clocker', '~> 0.1.6'
  spec.add_runtime_dependency 'gems', '~> 0.8.3'

  # sound systems
  #spec.add_runtime_dependency 'feep', '~> 0.1.3'
  #spec.add_runtime_dependency 'win32-sound', '~> 0.6.0'
  #spec.add_runtime_dependency 'bloopsaphone', '>= 0.4'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rubocop', '~> 0.52.1'
  spec.add_development_dependency 'rspec', '~> 3.9.0'
  spec.add_development_dependency 'rspec-nc', '~> 0.3'
  spec.add_development_dependency 'guard', '~> 2.16'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
end
