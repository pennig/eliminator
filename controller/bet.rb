class BetController < Controller
    def view(season,week_type,week_number,survival_pickem="survival",headsup_ats="h",regular_reverse="reg")
        mode = parse_modes(survival_pickem,headsup_ats,regular_reverse)
        @title = "View Bets"

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
end
