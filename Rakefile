require 'rubygems'
require 'rspec/core/rake_task'

task :default => :spec
RSpec::Core::RakeTask.new(:spec)

desc "Migrate from old to new"
task :legacy_migration do
    require './migration/legacy/legacy_migration.rb'
end

