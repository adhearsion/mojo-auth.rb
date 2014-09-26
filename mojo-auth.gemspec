# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mojo-auth/version'

Gem::Specification.new do |spec|
  spec.name          = "mojo-auth"
  spec.version       = MojoAuth::VERSION
  spec.authors       = ["Ben Langfeld"]
  spec.email         = ["ben@langfeld.me"]
  spec.summary       = %q{Implementation of MojoAuth in Ruby}
  spec.description   = %q{MojoAuth is a set of standard approaches to cross-app authentication based on HMAC.}
  spec.homepage      = "https://github.com/mojolingo/mojo-auth.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
