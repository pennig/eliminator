require 'net/http'
require 'nokogiri'
require 'ostruct'

class BoxScoreParser
    def initialize(game_id)
        raw_data = Net::HTTP.get(URI('http://www.nfl.com/widget/gc/2011/tabs/cat-post-boxscore?gameId='+game_id))
        if raw_data.size < 1000
            #sometimes NFL.com gives a 404 for no reason. wait and try one more time
            sleep(5)
            raw_data = Net::HTTP.get(URI('http://www.nfl.com/widget/gc/2011/tabs/cat-post-boxscore?gameId='+game_id))
        end
        result = raw_data.scan(/<table width="100%" border="0" cellspacing="0" cellpadding="0" class="gc-box-score-table">.*?<\/table>/m)
        begin
            processed_box_score = result[1].gsub(/<([A-Za-z]+)[^>]*>/,'<\1>')
        rescue => e
            puts raw_data
            puts result
            raise e
        end
        @box_score = Nokogiri::XML(processed_box_score)
    end

    def get_statistic(stat,home_away)
        if home_away == "home"
            node = 9
        else
            node = 3
        end
        @box_score.xpath("//tr[td/. ='#{stat}']")[0].children[node].children[0].to_s
    end

    def stats_for(home_away)
        game_stat = OpenStruct.new
        game_stat.turnovers = get_statistic("Pass Comp-Att-Int",home_away).split("-")[2].to_i + get_statistic("Fumbles (Number-Lost)",home_away).split("-")[1].to_i
        game_stat.rushing_yards = get_statistic("Net Yards Rushing",home_away).to_i
        game_stat.rushing_attempts = get_statistic("Total Rushing Plays",home_away).to_i
        game_stat.passing_yards = get_statistic("Net Yards Passing",home_away).to_i
        game_stat.passing_attempts = get_statistic("Pass Comp-Att-Int",home_away).split("-")[1].to_i
        game_stat.passing_completions = get_statistic("Pass Comp-Att-Int",home_away).split("-")[0].to_i
        game_stat.sacks = get_statistic("Times Sacked (Number-Yards)",home_away).split(" - ")[0].to_i
        game_stat.sack_yards_lost = get_statistic("Times Sacked (Number-Yards)",home_away).split(" - ")[1].to_i
        game_stat.interceptions_thrown = get_statistic("Pass Comp-Att-Int",home_away).split("-")[2].to_i
        game_stat.interception_returns = get_statistic("Interception Returns (Number-Yards)",home_away).split("-")[0].to_i
        game_stat.interception_return_yards = get_statistic("Interception Returns (Number-Yards)",home_away).split("-")[1].to_i
        game_stat.rushing_1st_downs = get_statistic("By Rushing",home_away).to_i
        game_stat.passing_1st_downs = get_statistic("By Passing",home_away).to_i
        game_stat.penalty_1st_downs = get_statistic("By Penalty",home_away).to_i

        third_down = get_statistic("Third Down Efficiency",home_away).sub(/-.*/,'').split("/")

        game_stat.third_down_attempts = third_down[1].to_i
        game_stat.third_down_conversions = third_down[0].to_i

        fourth_down = get_statistic("Fourth Down Efficiency",home_away).sub(/-.*/,'').split("/")

        game_stat.fourth_down_attempts = fourth_down[1].to_i
        game_stat.fourth_down_conversions = fourth_down[0].to_i
        game_stat.punts = get_statistic("Punts (Number-Average)",home_away).split("-")[0].to_i
        game_stat.punts_blocked = get_statistic("Blocked",home_away).to_i
        game_stat.punt_average_distance = get_statistic("Punts (Number-Average)",home_away).split("-")[1].to_f
        game_stat.punt_net_average = get_statistic("Net Punting Average",home_away).to_f
        game_stat.punt_returns = get_statistic("Punt Returns (Number-Yards)",home_away).split("-")[0].to_i
        game_stat.punt_return_yards = get_statistic("Punt Returns (Number-Yards)",home_away).split("-")[1].to_i
        game_stat.kickoffs = get_statistic("Kickoffs (Number-In End Zone-Touchbacks)",home_away).split("-")[0].to_i
        game_stat.kickoffs_in_endzone = get_statistic("Kickoffs (Number-In End Zone-Touchbacks)",home_away).split("-")[1].to_i
        game_stat.kickoffs_touchback = get_statistic("Kickoffs (Number-In End Zone-Touchbacks)",home_away).split("-")[2].to_i
        game_stat.kickoff_returns = get_statistic("Kickoff Returns (Number-Yards)",home_away).split("-")[0].to_i
        game_stat.kickoff_return_yards = get_statistic("Kickoff Returns (Number-Yards)",home_away).split("-")[1].to_i
        game_stat.penalties = get_statistic("Penalties (Number-Yards)",home_away).split("-")[0].to_i
        game_stat.penalty_yards = get_statistic("Penalties (Number-Yards)",home_away).split("-")[1].to_i
        game_stat.fumbles = get_statistic("Fumbles (Number-Lost)",home_away).split("-")[0].to_i
        game_stat.fumbles_lost = get_statistic("Fumbles (Number-Lost)",home_away).split("-")[1].to_i
        top = get_statistic("Time of Possession",home_away)
        top = top.split(":")[0].to_i * 60 + top.split(":")[1].to_i
        game_stat.time_of_possession = top
        game_stat.rushing_tds = get_statistic("Rushing",home_away).to_i
        game_stat.passing_tds = get_statistic("Passing",home_away).to_i
        game_stat.other_tds = get_statistic("Interceptions",home_away).to_i + get_statistic("Kickoff Returns",home_away).to_i + get_statistic("Fumble Returns",home_away).to_i + get_statistic("Punt Returns",home_away).to_i
        game_stat.xp_attempts = get_statistic("Extra Points (Made-Attempted)",home_away).split("-")[1].to_i
        game_stat.xp_conversions = get_statistic("Extra Points (Made-Attempted)",home_away).split("-")[0].to_i
        game_stat.xp_blocked = get_statistic("FGs Blocked - PATs Blocked",home_away).split("-")[1].to_i
        game_stat.fg_attempts = get_statistic("Field Goals (Made-Attempted)",home_away).split("-")[1].to_i
        game_stat.fg_conversions = get_statistic("Field Goals (Made-Attempted)",home_away).split("-")[0].to_i
        game_stat.fg_blocked = get_statistic("FGs Blocked - PATs Blocked",home_away).split("-")[0].to_i

        goal_to_go = get_statistic("Goal To Go Efficiency",home_away).sub(/-.*/,'').split("/")

        game_stat.goal_to_go_attempts = goal_to_go[1].to_i
        game_stat.goal_to_go_successes = goal_to_go[0].to_i

        red_zone = get_statistic("Red Zone Efficiency",home_away).sub(/-.*/,'').split("/")

        game_stat.red_zone_attempts = red_zone[1].to_i
        game_stat.red_zone_successes = red_zone[0].to_i
        game_stat.safeties = get_statistic("Safeties",home_away).to_i
        game_stat
    end
end
