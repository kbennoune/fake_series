require "bundler/gem_tasks"
require "rake/testtask"
import "lib/tasks/series.rake"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

Rake::TestTask.new(:bench) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.pattern = "test/benchmarks/**/*_benchmark.rb"
end

task :default => :test
