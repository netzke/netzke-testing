source 'https://rubygems.org'

gemspec

gem 'rails', '~>4.2.0'
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
  gem 'netzke-core', github: 'netzke/netzke-core', branch: '2-0-0'
end
