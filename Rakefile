require 'rake'
require 'rake/testtask'

$VERBOSE = true

desc "Run all unit tests"
task :default => [ :test ]

desc "Run all unit tests together"
Rake::TestTask.new do |t|
  t.test_files = FileList['test/unit/tc_*.rb']
end

desc "Run the unit tests in test/"
task :test_units do
  Dir.glob('test/unit/*').each do |t|
    puts `/usr/bin/env ruby #{t}`
  end
end

