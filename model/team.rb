class Team

    def opponent_statistics(season=nil)
        if season.nil?
            VOpponentStatistics.where(:team_id => self.id).all
        else
            VOpponentStatistics.where(:team_id => self.id, :season => season).first
        end
    end

    def statistics(season=nil)
        if season.nil?
            VTeamStatistics.where(:team_id => self.id).all
        else
            VTeamStatistics.where(:team_id => self.id, :season => season).first
        end
    end

    def record(season=nil)
        if season.nil?
            FullRecord.where(:team_id => self.id).to_hash(:season)
        else
            FullRecord.where(:team_id => self.id, :season => season).first
        end
    end
end

