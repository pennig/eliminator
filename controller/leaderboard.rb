class LeaderboardController < Controller
    def eliminator(season=current_season,group="public",headsup_ats="h",regular_reverse="reg")
        @season = season
        @season_path = build_path
        if headsup_ats == "h"
            if regular_reverse == "reg"
                @bet_record =  eliminator_headsup_regular(season,group)
            else
                @bet_record =  eliminator_headsup_reverse(season,group)
            end
        else
            if regular_reverse == "reg"
                @bet_record =  eliminator_ats_regular(season,group)
            else
                @bet_record =  eliminator_ats_reverse(season,group)
            end
        end

    end

    def pickem
    end

    private

    def eliminator_headsup_regular(season,group)
        #ugh. concatenation of a query. this needs to change
        if group.nil? or group == "public"
            group_sql= "and group_id is null"
        else
            group_sql= "and group_id = ?"
        end
        $db_connection["select user_id, username, sum(won) as won, sum(lost) as lost
            from
            (select b.user_id AS user_id,
               b.team_id AS team_id,
               (case when ((gr.status = 'FINAL') and (gr.winning_team_id = b.team_id)) then 1 else 0 end) AS won,
               (case when ((gr.status = 'FINAL') and ((gr.winning_team_id <> b.team_id) or isnull(gr.winning_team_id))) then 1 else 0 end) AS lost
            from ((bets b join game_results gr on((gr.game_id = b.game_id))) join spread s on((b.spread_id = s.id))
            	join bet_sets bs on((b.bet_set_id = bs.id)) )
            where b.survival_pickem = 0 and b.headsup_ats = 0 and b.regular_reverse = 0 and season = ? #{group_sql}) unsummed
            join users on unsummed.user_id = users.id
            group by user_id
            order by won desc,lost asc",season,group]
    end

    def eliminator_headsup_reverse(season,group)
        #ugh. concatenation of a query. this needs to change
        if group.nil? or group == "public"
            group_sql= "and group_id is null"
        else
            group_sql= "and group_id = ?"
        end
        $db_connection["select user_id, username, sum(won) as won, sum(lost) as lost
            from
            (select b.user_id AS user_id,
               b.team_id AS team_id,
               (case when ((gr.status = 'FINAL') and (gr.winning_team_id is not null) and (gr.winning_team_id <> b.team_id)) then 1 else 0 end) AS won,
               (case when ((gr.status = 'FINAL') and ((gr.winning_team_id = b.team_id) or isnull(gr.winning_team_id))) then 1 else 0 end) AS lost
            from ((bets b join game_results gr on((gr.game_id = b.game_id)))
            	join bet_sets bs on((b.bet_set_id = bs.id)) )
            where b.survival_pickem = 0 and b.headsup_ats = 0 and b.regular_reverse = 1 and season = ? #{group_sql}) unsummed
            join users on unsummed.user_id = users.id
            group by user_id
            order by won desc,lost asc",season,group]
    end

    def eliminator_ats_regular(season,group)
        #ugh. concatenation of a query. this needs to change
        if group.nil? or group == "public"
            group_sql= "and group_id is null"
        else
            group_sql= "and group_id = ?"
        end
        $db_connection["select user_id, username, sum(won) as won, sum(lost) as lost
            from
            (select b.user_id AS user_id,
               b.season AS season,
               b.week_number AS week_number,
               b.week_type AS week_type,
               b.game_id AS game_id,
               b.team_id AS team_id,
               (case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) < s.spread)) then 1 else 0 end) AS won,
               (case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) > s.spread)) then 1 else 0 end) AS lost,
               (case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) = s.spread)) then 1 else 0 end) AS push
            from ((bets b join game_results gr on((gr.game_id = b.game_id))) join spread s on((b.spread_id = s.id))
            join bet_sets bs on((b.bet_set_id = bs.id)) )
            where b.survival_pickem = 0 and b.headsup_ats = 1 and b.regular_reverse = 0 and season = ? #{group_sql}) unsummed
            join users on unsummed.user_id = users.id
            group by user_id
            order by won desc, lost asc",season,group]
    end

    def eliminator_ats_reverse(season,group)
        #ugh. concatenation of a query. this needs to change
        if group.nil? or group == "public"
            group_sql= "and group_id is null"
        else
            group_sql= "and group_id = ?"
        end
        $db_connection["select user_id, username, sum(won) as won, sum(lost) as lost
            from
            (select b.user_id AS user_id,
               b.season AS season,
               b.week_number AS week_number,
               b.week_type AS week_type,
               b.game_id AS game_id,
               b.team_id AS team_id,
               (case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) > s.spread)) then 1 else 0 end) AS won,
               (case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) < s.spread)) then 1 else 0 end) AS lost,
               (case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) = s.spread)) then 1 else 0 end) AS push
            from ((bets b join game_results gr on((gr.game_id = b.game_id))) join spread s on((b.spread_id = s.id))
            join bet_sets bs on((b.bet_set_id = bs.id)) )
            where b.survival_pickem = 0 and b.headsup_ats = 1 and b.regular_reverse = 1 and season = ? #{group_sql}) unsummed
            join users on unsummed.user_id = users.id
            group by user_id
            order by won desc, lost asc",season,group]
    end
end
