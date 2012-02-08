class BetController < Controller
    layout(:default) { !request.xhr? }

    def view(season,week_type,week_number,survival_pickem="survival",headsup_ats="h",regular_reverse="reg")
        mode = parse_modes(survival_pickem,headsup_ats,regular_reverse)
        @title = "View Bets"
        @season = season
        @season_path = build_path

        @bets = VBetWithUserTeamResult.where(
            :season => season,
            :week_type => week_type,
            :week_number => week_number,
            :survival_pickem => mode[:survival_pickem],
            :headsup_ats => mode[:headsup_ats],
            :regular_reverse => mode[:regular_reverse]
        )
    end

    def index
        login_required
        @title = "Make Bet"
    end

    def place(week_type,week_number,bet_set_id,game_id,team_id)
        login_required

        bet = Bet.new(
            :user_id => user.id,
            :game_id => game_id,
            :season => current_season,
            :week_number => week_number,
            :week_type => week_type,
            :team_id => team_id,
            :bet_set_id => bet_set_id
        )
        bet.valid_bet?(user,current_season,current_week_type,current_week_number)
        bet.save
        "{success:true}"
    end

    def choose(week_type=current_week_type,week_number=current_week_number,bet_set_id=nil)
        login_required

        @bet_sets = BetSet.where(:user_id => user.id)

        if bet_set_id.nil? or BetSet[bet_set_id.to_i].user_id != user.id
            bet_set_id = @bet_sets.where(:group_id => nil, :survival_pickem => 0, :headsup_ats => 0, :regular_reverse => 0).first.id
        end

        @data = bet_table_data(week_type, week_number, bet_set_id)
    end

    #ajax call
    def bet_table(week_type, week_number, bet_set_id)
        @data = bet_table_data(week_type, week_number, bet_set_id)
    end


    private
    def parse_modes(survival_pickem,headsup_ats,regular_reverse)
        if survival_pickem == "survival"
            survival_pickem = 0
        elsif survival_pickem == "pickem"
            survival_pickem = 1
        else
            survival_pickem = 0
        end

        if headsup_ats == "h"
            headsup_ats = 0
        elsif headsup_ats == "a"
            headsup_ats = 1
        else
            headsup_ats = 0
        end

        if regular_reverse == "reg"
            regular_reverse = 0
        elsif regular_reverse == "rev"
            regular_reverse = 1
        else
            regular_reverse = 0
        end
        {:survival_pickem => survival_pickem, :headsup_ats => headsup_ats, :regular_reverse => regular_reverse}
    end

    def bet_table_data(week_type, week_number, bet_set_id)
        login_required
        season = current_season
        bet_set = BetSet[bet_set_id.to_i]
        if bet_set.user_id != user.id
            raise StandardError, "Bet set is not owned by logged in user"
        end

        if bet_set.survival_pickem == false
            previous_bets = Bet.where(
                :user_id => user.id,
                :season => season,
                :week_type => week_type,
                :bet_set_id => bet_set_id
            )
            previous_bet_hash = {}
            previous_bets.map(:team_id).each do |team_id|
                previous_bet_hash[team_id] = true
            end
        end

        bets = Bet.where(
            :user_id => user.id,
            :season => season,
            :week_type => week_type,
            :week_number => week_number,
            :bet_set_id => bet_set_id
        )
        schedule = Schedule.join(:spread,:game_id => :game_id).where(
            :season => season,
            :week_type => week_type,
            :week_number => week_number
        )
        i = 0
        games_left_col = []
        games_right_col = []
        schedule.each do |game|
            i+=1
            if i.odd?
                games_left_col.push(game)
            else
                games_right_col.push(game)
            end
        end
        {:bet_set => bet_set, :bets => bets, :bets_array => bets.map(:team_id), :previous_bets => previous_bet_hash, :left_col => games_left_col, :right_col => games_right_col }
    end
end
