require "netzke/testing/version"
require "netzke/testing/helpers"
require "active_support/core_ext"

if defined? ::Rails
  require "netzke/testing/engine"
end

module Netzke
  module Testing
    mattr_accessor :spec_root

    def self.rspec_init(rspec_config)
      @@spec_root = Pathname.new(caller.first).join("../..")
      rspec_config.include(Netzke::Testing::Helpers)
    end

    def self.setup
      yield self
    end
  end
end
