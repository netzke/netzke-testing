module Netzke
  module Testing
    class Engine < ::Rails::Engine
      config.before_initialize do |app|
        Rails.application.config.assets.precompile += %w(netzke/testing/**/*.*)
      end
    end
  end
end
