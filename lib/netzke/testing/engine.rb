module Netzke
  module Testing
    class Engine < ::Rails::Engine
      config.before_initialize do |app|
        Rails.application.config.assets.precompile += %w(netzke/testing/**/*.*)
        Rails.application.config.assets.precompile += %w(netzke/testing.js)
      end
    end
  end
end
