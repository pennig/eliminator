class Bet
    self.plugin :timestamps
    def valid_bet?(current_season,current_week_type,current_week_number)
        game = Schedule.where(:game_id => self.game_id).first
        if game.nil?
            raise StandardError, "Invalid game"
        end
        if game.game_time <= Time.now
            raise StandardError, "You can't bet on games that have already kicked off"
        end
        if game.season < current_season
            raise StandardError, "You can only bet on this season"
        end
        if game.week_type != current_week_type
            raise StandardError, "Something"
        end
        if game.week_number != current_week_number
            raise StandardError, "Something"
        end
        if game.home_team_id != self.team_id and game.away_team_id != self.team_id
            raise StandardError, "The team chosen isn't playing in the game specified."
        end
        spread = Spread.where(:game_id => self.game_id).order(:created_at.desc).limit(1).first
        bet_set = BetSet[self.bet_set_id]
        if bet_set.user_id != self.user_id
            raise StandardError, "Bet set must belong to the logged in user"
        end
        if bet_set.headsup_ats == true and spread.nil?
            raise StandardError, "No spread is set for this game...we should do something"
        end
        if not spread.nil?
            self.spread_id = spread.id
        end

        self.survival_pickem = bet_set.survival_pickem
        self.headsup_ats = bet_set.headsup_ats
        self.regular_reverse = bet_set.regular_reverse

        #split off into helper methods that check the correctness of the 8 diff game types?
        if self.survival_pickem == false
            validate_survival(current_season,current_week_type,current_week_number)
        elsif self.survival_pickem == true
            validate_pickem
        end
    end

    private

    def validate_survival(season,week_type,week_number)
        puts "validating survival bet"
        #have they already bet on this week and that game has started?
        current_bet = Bet.where( :bet_set_id => bet_set_id, :user_id => self.user_id, :season => season, :week_type => week_type, :week_number => week_number ).first
        if not current_bet.nil?
            game = Schedule.where(:game_id => current_bet.game_id).first
            if game.game_time <= Time.now
                raise StandardError, "The game you have bet on has already kicked off. You can no longer change your bet."
            end
        end

        #have they bet on this team already?
        if Bet.where( :bet_set_id => bet_set_id, :user_id => self.user_id, :season => season, :team_id => self.team_id).count == 1
            raise StandardError, "You have already bet on this team this season"
        end

        #grab previous bet if present
        previous_bet = Bet.where(
            :bet_set_id => self.bet_set_id,
            :user_id => self.user_id,
            :season => season,
            :week_type => week_type,
            :week_number => week_number
        ).first
        if not previous_bet.nil?
            puts "found previous bet, deleting"
            previous_bet.delete
        end
    end

    def validate_pickem
        previous_bet = Bet.where(
            :game_id => self.game_id,
            :bet_set_id => self.bet_set_id,
            :user_id => self.user_id
        ).first
        if not previous_bet.nil?
            puts "found previous bet, deleting"
            previous_bet.delete
        end
    end

    def self.eliminator_headsup_regular(season,group)
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

    def self.eliminator_headsup_reverse(season,group)
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

    def self.eliminator_ats_regular(season,group)
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

    def self.eliminator_ats_reverse(season,group)
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
