#Ramaze::Route['/team\/([\w]+)\/([\w]+)'] = "/team/info/%s/%s"
Ramaze::Route['/team/([\w]+)'] = "/team/info/%s"
class TeamController < Controller
    def index(season=2011)
        @start_time = Time.now
        @afc = {}
        @nfc = {}
        @afc["east"] = Team.where(:conference => "AFC", :division => "East").all
        @afc["west"] = Team.where(:conference => "AFC", :division => "West").all
        @afc["north"] = Team.where(:conference => "AFC", :division => "North").all
        @afc["south"] = Team.where(:conference => "AFC", :division => "South").all
        @nfc["east"] = Team.where(:conference => "NFC", :division => "East").all
        @nfc["west"] = Team.where(:conference => "NFC", :division => "West").all
        @nfc["north"] = Team.where(:conference => "NFC", :division => "North").all
        @nfc["south"] = Team.where(:conference => "NFC", :division => "South").all
        @records = VFullRecord.where(:season => season).to_hash(:team_id)
        @season = season
    end

    def info(season=2011,team_identifier)
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
