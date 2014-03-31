require 'rake'
require 'rake/testtask'

$VERBOSE = true

desc "Default Task"
task :default => [ :test ]

desc "Run all unit tests."
task :test => ["test:bsd", "test:linux", "test:sunos"]

# The different os-specific files cannot be required in the same process, since
# the redefine the same symbols.  So we can't test them in a single test/unit
# process.  Instead, we'll split them up into the minimum possible number of
# processes, each with its own rake task.
Rake::TestTask.new do |t|
  t.name = "test:bsd"
  t.test_files = %w(darwin dragonflybsd freebsd netbsd openbsd osx).collect do |os|
    "test/unit/tc_#{os}.rb"
  end
end

Rake::TestTask.new do |t|
  t.name = "test:linux"
  t.test_files = %w(linux).collect do |os|
    "test/unit/tc_#{os}.rb"
  end
end

Rake::TestTask.new do |t|
  t.name = "test:sunos"
  t.test_files = %w(sunos).collect do |os|
    "test/unit/tc_#{os}.rb"
  end
end
