require 'rake'
require 'rake/testtask'

$VERBOSE = true

desc "Run all unit tests"
task :default => [ :test ]

desc "Run all unit tests together"
task :test do
  Dir.glob('./test/unit/*').each { |f| require f }
end

desc "Run the unit tests in test/"
task :test_units do
  Dir.glob('test/unit/*').each do |t|
    puts `/usr/bin/env ruby #{t}`
  end
end


