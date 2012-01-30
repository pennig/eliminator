class Schedule
    many_to_one :home_team, :class => Team, :key => :home_team_id
    many_to_one :away_team, :class => Team, :key => :away_team_id
    one_to_one :home_stats, :class => GameStats, :key => [:game_id, :team_id], :primary_key => [:game_id, :home_team_id]
    one_to_one :away_stats, :class => GameStats, :key => [:game_id, :team_id], :primary_key => [:game_id, :away_team_id]
    one_to_one :results, :class => GameResult, :key => :game_id, :primary_key => :game_id
end
