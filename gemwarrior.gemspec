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
  spec.add_runtime_dependency 'matrext', '~> 0.4.10'
  spec.add_runtime_dependency 'clocker', '~> 0.1.6'
  spec.add_runtime_dependency 'win32-sound', '~> 0.6.0'
  spec.add_runtime_dependency 'feep', '~> 0.1.3'
  spec.add_runtime_dependency 'gems', '~> 0.8.3'

  # gems for future features
  # spec.add_runtime_dependency 'hr', '~> 0.0.2'
  # spec.add_runtime_dependency 'github_api', '~> 0.12.4'
  
  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  
  spec.add_development_dependency 'rubocop', '~> 0.29'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-nc'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry-byebug', '~> 3.0'
end
