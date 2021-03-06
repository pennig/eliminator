class BetController < Controller
    layout(:default) { !request.xhr? }

    def view(season,week_type,week_number,survival_pickem="eliminator",headsup_ats="h",regular_reverse="reg")
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
        begin
            bet.valid_bet?(current_season,current_week_type,current_week_number)
            bet.save
            "{\"success\":true}"
        rescue => e
            "{\"error\":\"#{e.message}\"}"
        end
    end

    def choose(week_type=current_week_type,week_number=current_week_number,bet_set_id=nil)
        login_required

        @bet_sets = BetSet.where(:user_id => user.id)

        if bet_set_id.nil? or BetSet[bet_set_id.to_i].user_id != user.id
            bet_set_id = @bet_sets.where(:group_id => nil, :survival_pickem => 0, :headsup_ats => 0, :regular_reverse => 0).first.id
        end

        @data = bet_table_data(week_type, week_number, bet_set_id)
        @eliminator_bets = @data[:eliminator_bets]
    end

    #ajax call
    def bet_table(week_type, week_number, bet_set_id)
        @data = bet_table_data(week_type, week_number, bet_set_id)
        @eliminator_bets = @data[:eliminator_bets]
    end


    private
    def parse_modes(survival_pickem,headsup_ats,regular_reverse)
        if survival_pickem == "eliminator"
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
            game_type = "eliminator"

            eliminator_bets = user.eliminator_bets(season,week_type,bet_set_id)
            eliminator_bets_hash = {}
            eliminator_bets.map do |week,bet|
                if not bet.nil?
                    eliminator_bets_hash[bet.team_id] = true
                end
            end
        else
            game_type = "pickem"
        end

        bets = VBetWithUserTeamResult.where(
            :user_id => user.id,
            :season => season,
            :week_type => week_type,
            :week_number => week_number,
            :bet_set_id => bet_set_id
        )
        #TODO: this join needs to get the latest spread...so it's wrong right now
        schedule = Schedule.select(:schedule.*,:spread__spread).left_outer_join(:spread,:game_id => :game_id).where(
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
        {
            :bet_set => bet_set,
            :game_type => game_type,
            :bets => bets,
            :bets_array => bets.map(:team_id),
            :eliminator_bets => eliminator_bets,
            :eliminator_bets_hash => eliminator_bets_hash,
            :left_col => games_left_col,
            :right_col => games_right_col
        }
    end
end
