class TeamController < Controller
    def index(season=2011)
        @start_time = Time.now
        @afc = {}
        @nfc = {}
        @afc["east"] = VTeamWithRecord.where(:season => season, :conference => "AFC", :division => "East").order(:won.desc,:lost.asc,:tied.desc).all
        @afc["west"] = VTeamWithRecord.where(:season => season, :conference => "AFC", :division => "West").order(:won.desc,:lost.asc,:tied.desc).all
        @afc["north"] = VTeamWithRecord.where(:season => season, :conference => "AFC", :division => "North").order(:won.desc,:lost.asc,:tied.desc).all
        @afc["south"] = VTeamWithRecord.where(:season => season, :conference => "AFC", :division => "South").order(:won.desc,:lost.asc,:tied.desc).all
        @nfc["east"] = VTeamWithRecord.where(:season => season, :conference => "NFC", :division => "East").order(:won.desc,:lost.asc,:tied.desc).all
        @nfc["west"] = VTeamWithRecord.where(:season => season, :conference => "NFC", :division => "West").order(:won.desc,:lost.asc,:tied.desc).all
        @nfc["north"] = VTeamWithRecord.where(:season => season, :conference => "NFC", :division => "North").order(:won.desc,:lost.asc,:tied.desc).all
        @nfc["south"] = VTeamWithRecord.where(:season => season, :conference => "NFC", :division => "South").order(:won.desc,:lost.asc,:tied.desc).all
        @season = season
    end

    def info(season=2011,team_identifier=nil)
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
