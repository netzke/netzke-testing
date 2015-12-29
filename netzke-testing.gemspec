# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'netzke/testing/version'

Gem::Specification.new do |spec|
  spec.name          = "netzke-testing"
  spec.version       = Netzke::Testing::VERSION
  spec.authors       = ["Max Gorin"]
  spec.email         = ["max@goodbitlabs.com"]
  spec.summary       = "Testing helpers for Netzke applications and gems"
  spec.description   = "Provides help with developing and testing Netzke components"
  spec.homepage      = "http://netzke.org"

  spec.files         = Dir["{app,config,lib,spec}/**/*", "[A-Z]*"] - ["Gemfile.lock", "spec/rails_app/public/extjs"]
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "coffee-script"
end
