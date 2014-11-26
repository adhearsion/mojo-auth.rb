# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mojo_auth/version'

Gem::Specification.new do |spec|
  spec.name          = 'mojo_auth'
  spec.version       = MojoAuth::VERSION
  spec.authors       = ['Ben Langfeld']
  spec.email         = ['ben@langfeld.me']
  spec.summary       = 'Implementation of MojoAuth in Ruby'
  spec.description   = 'MojoAuth is a set of standard approaches to cross-app authentication based on HMAC.'
  spec.homepage      = 'https://github.com/mojolingo/mojo-auth.rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'guard', '~> 2.6'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.3'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'guard-rubocop', '~> 1.1'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'timecop', '~> 0.7'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'guard-yard'
end
