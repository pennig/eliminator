class TeamController < Controller
    def index(season=2011,team_identifier)
        if team_identifier.to_i > 0
            @team = Team[team_identifier]
        else
            @team = Team.where(:short_name => team_identifier.upcase).first
        end
        @stats = @team.statistics(season)
        @opp_stats = @team.opponent_statistics(season)

        @schedule_and_results = VScheduleAndResults.where( {:home_team_id => @team.id } | {:away_team_id => @team.id}, :season => season)
    end
end
