class Bet
    self.plugin :timestamps
    def validate(user,current_season,current_week_type,current_week_number)
        game = Schedule.where(:game_id => self.game_id).first
        if game.nil?
            raise StandardError, "Invalid game"
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
        if spread.nil?
            raise StandardError, "No spread is set for this game...we should do something"
        end
        self.spread_id = spread.id

        bet_set = BetSet[self.bet_set_id]
        if bet_set.user_id != user.id
            raise StandardError, "Bet set must belong to the logged in user"
        end
        self.survival_pickem = bet_set.survival_pickem
        self.headsup_ats = bet_set.headsup_ats
        self.regular_reverse = bet_set.regular_reverse

        #split off into helper methods that check the correctness of the 8 diff game types?
        if self.survival_pickem == 0
            validate_survival(current_season,current_week_type,current_week_number)
        elsif self.survival_pickem == 1
            validate_pickem
        end
    end

    private

    def validate_survival(current_season,current_week_type,current_week_number)
        previous_bet = Bet.where(
            :bet_set_id => self.bet_set_id,
            :user_id => user.id,
            :season => current_season,
            :week_type => current_week_type,
            :week_number => current_week_number
        ).first
        if not previous_bet.nil?
            #we already have a bet for this. we should update it, but instead we'll throw an error for now
            raise StandardError, "Better error goes here, but you can't bet twice."
        end
    end

    def validate_pickem
        previous_bet = Bet.where(
            :game_id => self.game_id,
            :bet_set_id => self.bet_set_id,
            :user_id => user.id
        ).first
        if not previous_bet.nil?
            #we already have a bet for this game. we should update it, but instead we'll throw an error for now
            raise StandardError, "Better error goes here, but you can't bet twice."
        end
    end

end
