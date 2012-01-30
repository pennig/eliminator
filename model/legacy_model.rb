require 'rubygems'
require 'sequel'

config = YAML::load(File.open("config.yaml"))

$legacy_db = Sequel.connect(
    :adapter => "mysql2",
    :host => config["legacy_db"]["host"],
    :user => config["legacy_db"]["user"],
    :password => config["legacy_db"]["password"],
    :database => config["legacy_db"]["database"]
)

class LegacyBets < Sequel::Model(:bets)
    self.db = $legacy_db
end

class LegacyScheduleAndStats < Sequel::Model(:league)
    self.db = $legacy_db
end

class LegacyTeams < Sequel::Model(:teams)
    self.db = $legacy_db
end

class LegacyUsers < Sequel::Model(:accounts)
    self.db = $legacy_db
end
