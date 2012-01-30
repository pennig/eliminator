require 'rubygems'
require 'sequel'
require 'bcrypt'

class BetSet < Sequel::Model(:bet_sets)
    self.db = $db_connection
end

class Bet < Sequel::Model(:bets)
    self.db = $db_connection
end

class GameResult < Sequel::Model(:game_results)
    self.db = $db_connection
end

class GameStats < Sequel::Model(:game_stats)
    self.db = $db_connection
end

class GroupFeature < Sequel::Model(:group_features)
    self.db = $db_connection
end

class Group < Sequel::Model(:groups)
    self.db = $db_connection
end

class OverUnder < Sequel::Model(:over_under)
    self.db = $db_connection
end

class PowerRankingAlgorithm < Sequel::Model(:power_ranking_algorithms)
    self.db = $db_connection
end

class Team < Sequel::Model(:teams)
    self.db = $db_connection

end

class Schedule < Sequel::Model(:schedule)
    self.db = $db_connection
end

class Spread < Sequel::Model(:spread)
    self.db = $db_connection
end

class UserInfo < Sequel::Model(:user_info)
    self.db = $db_connection
end

class User < Sequel::Model(:users)
    self.db = $db_connection

end
