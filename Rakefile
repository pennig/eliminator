require 'rubygems'
require 'rspec/core/rake_task'

task :default => :spec
RSpec::Core::RakeTask.new(:spec)

desc "Migrate from old to new"
task :legacy_migration do
    require './lib/legacy_migration/legacy_migration.rb'
end
