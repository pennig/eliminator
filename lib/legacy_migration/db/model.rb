require 'rubygems'
require 'sequel'

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
