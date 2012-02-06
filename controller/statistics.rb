class StatisticsController < Controller
    def index(off_def,season=2011)
        @season = season
        if off_def == "offense"
            @stats = VTeamStatistics.where(:season => @season).order(:avg_points.desc)
            @stat_type = "offense"
        else
            @stats = VOpponentStatistics.where(:season => @season).order(:avg_points.asc)
            @stat_type = "defense"
        end
        @season_path = "/statistics/#{@stat_type}/"
    end
end

