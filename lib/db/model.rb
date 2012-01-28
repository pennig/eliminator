require 'rubygems'
require 'sequel'

class BetSets < Sequel::Model(:bet_sets)
    self.db = $db_connection
end

class Bets < Sequel::Model(:bets)
    self.db = $db_connection
end

class GameResults < Sequel::Model(:game_results)
    self.db = $db_connection
end

class GameStats < Sequel::Model(:game_stats)
    self.db = $db_connection
end

class GroupFeatures < Sequel::Model(:group_features)
    self.db = $db_connection
end

class Groups < Sequel::Model(:groups)
    self.db = $db_connection
end

class OverUnder < Sequel::Model(:over_under)
    self.db = $db_connection
end

class PowerRankingAlgorithms < Sequel::Model(:power_ranking_algorithms)
    self.db = $db_connection
end

class Schedule < Sequel::Model(:schedule)
    self.db = $db_connection
end

class Spread < Sequel::Model(:spread)
    self.db = $db_connection
end

class Teams < Sequel::Model(:teams)
    self.db = $db_connection
end

class UserInfo < Sequel::Model(:user_info)
    self.db = $db_connection
end

class Users < Sequel::Model(:users)
    self.db = $db_connection
end
