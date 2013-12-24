require "bundler/gem_tasks"

desc "Run all tests"
task :test do
  system("bundle exec rspec spec") || abort
end

task default: :test
