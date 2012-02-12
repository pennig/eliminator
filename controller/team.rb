class TeamController < Controller
    def index(season=current_season)
        @season = season
        @season_path = build_path

        @start_time = Time.now
        @afc = {}
        @nfc = {}
        @afc["east"] = VTeamWithRecord.where(:season => season, :conference => "AFC", :division => "East").order(:won.desc,:lost.asc,:tied.desc,:afc_east_won.desc,:afc_east_lost.asc,:afc_east_tied.desc).all
        @afc["west"] = VTeamWithRecord.where(:season => season, :conference => "AFC", :division => "West").order(:won.desc,:lost.asc,:tied.desc,:afc_west_won.desc,:afc_west_lost.asc,:afc_west_tied.desc).all
        @afc["north"] = VTeamWithRecord.where(:season => season, :conference => "AFC", :division => "North").order(:won.desc,:lost.asc,:tied.desc,:afc_north_won.desc,:afc_north_lost.asc,:afc_north_tied.desc).all
        @afc["south"] = VTeamWithRecord.where(:season => season, :conference => "AFC", :division => "South").order(:won.desc,:lost.asc,:tied.desc,:afc_south_won.desc,:afc_south_lost.asc,:afc_south_tied.desc).all
        @nfc["east"] = VTeamWithRecord.where(:season => season, :conference => "NFC", :division => "East").order(:won.desc,:lost.asc,:tied.desc,:nfc_east_won.desc,:nfc_east_lost.asc,:nfc_east_tied.desc).all
        @nfc["west"] = VTeamWithRecord.where(:season => season, :conference => "NFC", :division => "West").order(:won.desc,:lost.asc,:tied.desc,:nfc_west_won.desc,:nfc_west_lost.asc,:nfc_west_tied.desc).all
        @nfc["north"] = VTeamWithRecord.where(:season => season, :conference => "NFC", :division => "North").order(:won.desc,:lost.asc,:tied.desc,:nfc_north_won.desc,:nfc_north_lost.asc,:nfc_north_tied.desc).all
        @nfc["south"] = VTeamWithRecord.where(:season => season, :conference => "NFC", :division => "South").order(:won.desc,:lost.asc,:tied.desc,:nfc_south_won.desc,:nfc_south_lost.asc,:nfc_south_tied.desc).all
        @streak = Team.streak(@season).to_hash(:team_id)
    end

    def info(season=2011,team_identifier=nil)
        @season = season
        @season_path = build_path

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
