class GameController < Controller
    def info(game_id)
        @schedule = Schedule.where(:game_id => game_id).first
        @season = @schedule.season
        @season_path = build_path
        @results = @schedule.results
        @home_stats = GameStats.where(:game_id => game_id, :team_id => @schedule.home_team_id).first
        @away_stats = GameStats.where(:game_id => game_id, :team_id => @schedule.away_team_id).first
    end
end
