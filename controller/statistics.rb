class StatisticsController < Controller
    def index(off_def,season=2011)
        @season = season
        @season_path = build_path
        if off_def == "offense"
            @stats = VTeamStatistics.where(:season => @season).order(:avg_points.desc)
            @stat_type = "offense"
        else
            @stats = VOpponentStatistics.where(:season => @season).order(:avg_points.asc)
            @stat_type = "defense"
        end
    end
end

