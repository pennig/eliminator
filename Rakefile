require 'rubygems'
require 'rspec/core/rake_task'

task :default => :spec
RSpec::Core::RakeTask.new(:spec)

desc "Migrate from old to new"
namespace :migration do
    task :legacy do
        require './migration/legacy/legacy_migration.rb'
    end

    desc "Update game stats (not results) for all games"
    task :update_game_stats do
        require './migration/updategamestats.rb'
    end
end
