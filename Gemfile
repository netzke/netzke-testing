source 'https://rubygems.org'

gemspec

gem 'rails', '~>5.1.0'
gem 'sqlite3'
gem 'yard'
gem 'rake'

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'capybara-selenium'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

group :development do
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'pry-rails'
  gem 'netzke-core', github: 'thepry/netzke-core', branch: 'ext-js-6-0-0'
end
