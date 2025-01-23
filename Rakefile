require "rake/extensiontask"
require "rake/testtask"

Rake::ExtensionTask.new("nanosleep")

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end
