class GameController < Controller
    def index(game_id=nil)
        @schedule = Schedule.where(:game_id => game_id).first
        @results = @schedule.results
        @home_stats = GameStats.where(:game_id => game_id, :team_id => @schedule.home_team_id).first
        @away_stats = GameStats.where(:game_id => game_id, :team_id => @schedule.away_team_id).first
    end
end
