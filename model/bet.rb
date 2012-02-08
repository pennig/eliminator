class Bet
    self.plugin :timestamps
    def valid_bet?(user,current_season,current_week_type,current_week_number)
        game = Schedule.where(:game_id => self.game_id).first
        if game.nil?
            raise StandardError, "Invalid game"
        end
        #if game.game_time <= Time.now
        #    raise StandardError, "You can't bet on games that have already kicked off"
        #end
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
        if self.survival_pickem == false
            validate_survival(user,current_season,current_week_type,current_week_number)
        elsif self.survival_pickem == true
            validate_pickem
        end
    end

    private

    def validate_survival(user,current_season,current_week_type,current_week_number)
        puts "validating survival bet"
        if Bet.where( :bet_set_id => bet_set_id, :user_id => user.id, :season => current_season, :team_id => self.team_id).count > 0
            raise StandardError, "You have already bet on this team this season"
        end


        previous_bet = Bet.where(
            :bet_set_id => self.bet_set_id,
            :user_id => user.id,
            :season => current_season,
            :week_type => current_week_type,
            :week_number => current_week_number
        ).first
        puts Bet.where(
            :bet_set_id => self.bet_set_id,
            :user_id => user.id,
            :season => current_season,
            :week_type => current_week_type,
            :week_number => current_week_number
        ).sql
        if not previous_bet.nil?
            puts "found previous bet, deleting"
            previous_bet.delete
        end
    end

    def validate_pickem
        previous_bet = Bet.where(
            :game_id => self.game_id,
            :bet_set_id => self.bet_set_id,
            :user_id => user.id
        ).first
        if not previous_bet.nil?
            puts "found previous bet, deleting"
            previous_bet.delete
        end
    end

end
