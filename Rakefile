# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.name = "test"
  t.libs << "test"
  t.test_files = Dir["test/*test*.rb"]
  t.verbose = true
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]
