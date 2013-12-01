# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'netzke/testing/version'

Gem::Specification.new do |spec|
  spec.name          = "netzke-testing"
  spec.version       = Netzke::Testing::VERSION
  spec.authors       = ["Max Gorin"]
  spec.email         = ["gorinme@gmail.com"]
  spec.summary       = "Testing helpers for Netzke applications and gems"
  spec.description   = "Provides help with developing and testing Netzke components"
  spec.homepage      = "http://netzke.org"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "coffee-script"
end
