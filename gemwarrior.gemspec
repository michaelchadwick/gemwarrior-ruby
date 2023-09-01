# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'gemwarrior/version'

Gem::Specification.new do |spec|
  # required
  spec.name     = 'gemwarrior'
  spec.summary  = 'RubyGem text adventure'
  spec.version  = Gemwarrior::VERSION
  spec.authors  = ['Michael Chadwick']
  spec.files    = `git ls-files`.split("\n")

  # recommended
  spec.description            = 'A fun text adventure in the form of a RubyGem!'
  spec.email                  = 'mike@neb.host'
  spec.homepage               = 'https://github.com/michaelchadwick/gemwarrior'
  spec.license                = 'MIT'
  spec.metadata               = {
                                  "documentation_uri" => "https://github.com/michaelchadwick/gemwarrior",
                                  "homepage_uri" => "https://github.com/michaelchadwick/gemwarrior",
                                  "source_code_uri" => "https://github.com/michaelchadwick/gemwarrior"
                                }
  spec.required_ruby_version  = '~> 2.0'

  # additional
  ## runtime deps
  spec.add_runtime_dependency 'clocker', '~> 0.1.6'
  spec.add_runtime_dependency 'colorize', '~> 1.0'
  spec.add_runtime_dependency 'gems', '~> 1.2'
  spec.add_runtime_dependency 'http', '~> 5.1'
  spec.add_runtime_dependency 'json', '~> 2.6'
  spec.add_runtime_dependency 'matrext', '~> 1.0'
  spec.add_runtime_dependency 'os', '~> 0.9', '>= 0.9.6'
  spec.add_runtime_dependency 'psych', '~> 5.1'
    ## sound systems
    #spec.add_runtime_dependency 'feep', '~> 0.1.3'
    #spec.add_runtime_dependency 'win32-sound', '~> 0.6.0'
    #spec.add_runtime_dependency 'bloopsaphone', '>= 0.4'
  # spec.platform             = Gem::Platform::RUBY
  spec.post_install_message   = "Type 'gemwarrior' to start adventuring!"
  # spec.require_paths        = ['lib']
  ## development deps
  spec.add_development_dependency 'awesome_print', '~> 1.9'
  spec.add_development_dependency 'bundler', '~> 2.4'
  spec.add_development_dependency 'bundler-audit', '~> 0.9'
  spec.add_development_dependency 'guard', '~> 2.18'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'pry-byebug', '~> 3.10'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12.0'
  spec.add_development_dependency 'rspec-nc', '~> 0.3'
  spec.add_development_dependency 'rubocop', '~> 1.50'
end
