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

    #this probably needs to be in a better place
    def self.streak(season)
        self.db["select team_id,
            case when won_position < lost_position and won_position > 0 then concat('Won ', lost_position - won_position)
            when won_position < lost_position and won_position = 0 then concat('Lost 16')
            when won_position > lost_position and lost_position = 0 then concat('Won 16')
            else concat('Lost ', won_position - lost_position) end streak
            from
            (select team_id,season,
            find_in_set('0', 1st) lost_position,
            find_in_set('1', 1st) won_position
            from
            (
            select team_id,season, group_concat(won order by week_number desc) as 1st
            from
            (
            select game_id,week_number,season,home_team_id as team_id,
            case when (home_team_id = winning_team_id) then 1 else 0 end as won,
            case when (home_team_id <> winning_team_id and winning_team_id is not null) then 1 else 0 end as lost,
            case when (winning_team_id is null) then 1 else 0 end as tied

            from v_schedule_and_results
            join teams t on t.id=home_team_id
            join teams ot on ot.id=away_team_id
            where status='FINAL' and season = ?
            union all
            select game_id,week_number,season,away_team_id as team_id,
            case when (away_team_id = winning_team_id) then 1 else 0 end as won,
            case when (away_team_id <> winning_team_id and winning_team_id is not null) then 1 else 0 end as lost,
            case when (winning_team_id is null) then 1 else 0 end as tied

            from v_schedule_and_results
            join teams t on t.id=away_team_id
            join teams ot on ot.id=home_team_id
            where status='FINAL' and season = ?) thing
            group by team_id
            order by team_id asc) alias) derived",season,season]
    end
end

