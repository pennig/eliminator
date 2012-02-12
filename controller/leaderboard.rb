class LeaderboardController < Controller
    def eliminator(season=current_season,group="public",headsup_ats="h",regular_reverse="reg")
        @season = season
        @season_path = build_path
        @group = group
        @survival_pickem = "survival"
        if headsup_ats == "h"
            @headsup_ats = "h"
            if regular_reverse == "reg"
                @regular_reverse = "reg"
                @bet_record =  Bet.eliminator_headsup_regular(season,group)
            else
                @regular_reverse = "rev"
                @bet_record =  Bet.eliminator_headsup_reverse(season,group)
            end
        else
            @headsup_ats = "a"
            if regular_reverse == "reg"
                @regular_reverse = "reg"
                @bet_record =  Bet.eliminator_ats_regular(season,group)
            else
                @regular_reverse = "rev"
                @bet_record =  Bet.eliminator_ats_reverse(season,group)
            end
        end

        if logged_in?
            @groups = Group.join(:group_members, :group_id => :id).where(:user_id => user.id)
            @bet_sets = BetSet.where(:user_id => user.id)
        end

    end

    def pickem
    end

    private
    def is_active?(group_id,survival_pickem,headsup_ats,regular_reverse)
        ((@group.to_i == group_id or @group == group_id) and @headsup_ats == headsup_ats and @regular_reverse == regular_reverse and @survival_pickem == survival_pickem)
    end

    def build_url(bet_set)
        url = "/leaderboard/"
        if bet_set.survival_pickem == false then url += "eliminator/" else url += "pickem/" end
        url += "#{@season}/#{bet_set.group_id}/"
        if bet_set.headsup_ats == false then url += "h/" else url += "a/" end
        if bet_set.regular_reverse == false then url += "reg" else url += "rev" end
        url
    end
end
