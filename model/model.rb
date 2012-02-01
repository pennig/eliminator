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

class GroupMember < Sequel::Model(:group_members)
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

class VTeamSchedule < Sequel::Model(:v_team_schedule)
    self.db = $db_connection
end

class VTeamStatistics < Sequel::Model(:v_team_statistics)
    self.db = $db_connection
end

class VOpponentStatistics < Sequel::Model(:v_opponent_statistics)
    self.db = $db_connection
end

class VScheduleAndResults < Sequel::Model(:v_schedule_and_results)
    many_to_one :home_team, :class => Team, :key => :home_team_id
    many_to_one :away_team, :class => Team, :key => :away_team_id

    self.db = $db_connection
end

class VTeamRecord < Sequel::Model(:v_team_records)
    self.db = $db_connection
end
class VFullRecord < Sequel::Model(:v_full_records)
    self.db = $db_connection
end

class FullRecord < Sequel::Model(:full_records)
    self.db = $db_connection
end

class VTeamWithRecord < Sequel::Model(:v_teams_with_records)
    self.db = $db_connection
end
