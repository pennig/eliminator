require 'spec_helper'
require 'boxscoreparser'

describe BoxScoreParser do
    before :each do
        Net::HTTP.stub!(:get).and_return(SCRAPED_GAME_STATS)
    end
    it "parses and returns away stats properly" do
        parser = BoxScoreParser.new("2011111310")
        stats = parser.build_stat_object("away")
        stats.turnovers.should == 2
        stats.rushing_yards.should == 133
        stats.rushing_attempts.should == 32
        stats.passing_yards.should == 148
        stats.passing_attempts.should == 25
        stats.passing_completions.should == 15
        stats.sacks.should == 1
        stats.sack_yards_lost.should == 7
        stats.interceptions_thrown.should == 1
        stats.interception_returns.should == 0
        stats.interception_return_yards.should == 0
        stats.rushing_1st_downs.should == 8
        stats.passing_1st_downs.should == 8
        stats.penalty_1st_downs.should == 0
        stats.third_down_attempts.should == 12
        stats.third_down_conversions.should == 4
        stats.fourth_down_attempts.should == 0
        stats.fourth_down_conversions.should == 0
        stats.punts.should == 5
        stats.punts_blocked.should == 0
        stats.punt_average_distance.should == 47.2
        stats.punt_net_average.should == 42.0
        stats.punt_returns.should == 3
        stats.punt_return_yards.should == 25
        stats.kickoffs.should == 4
        stats.kickoffs_in_endzone.should == 3
        stats.kickoffs_touchback.should == 2
        stats.kickoff_returns.should == 3
        stats.kickoff_return_yards.should == 52
        stats.penalties.should == 7
        stats.penalty_yards.should == 55
        stats.fumbles.should == 1
        stats.fumbles_lost.should == 1
        stats.time_of_possession.should == 1653
        stats.rushing_tds.should == 0
        stats.passing_tds.should == 1
        stats.other_tds.should == 0
        stats.xp_attempts.should == 1
        stats.xp_conversions.should == 1
        stats.xp_blocked.should == 0
        stats.fg_attempts.should == 2
        stats.fg_conversions.should == 2
        stats.fg_blocked.should == 0
        stats.goal_to_go_attempts.should == 0
        stats.goal_to_go_successes.should == 0
        stats.red_zone_attempts.should == 3
        stats.red_zone_successes.should == 1
        stats.safeties.should == 0
    end
    it "parses and returns home stats properly" do
        parser = BoxScoreParser.new("2011111310")
        stats = parser.build_stat_object("home")
        stats.turnovers.should == 1
        stats.rushing_yards.should == 126
        stats.rushing_attempts.should == 30
        stats.passing_yards.should == 209
        stats.passing_attempts.should == 27
        stats.passing_completions.should == 20
        stats.sacks.should == 2
        stats.sack_yards_lost.should == 9
        stats.interceptions_thrown.should == 0
        stats.interception_returns.should == 1
        stats.interception_return_yards.should == 3
        stats.rushing_1st_downs.should == 5
        stats.passing_1st_downs.should == 9
        stats.penalty_1st_downs.should == 0
        stats.third_down_attempts.should == 14
        stats.third_down_conversions.should == 5
        stats.fourth_down_attempts.should == 0
        stats.fourth_down_conversions.should == 0
        stats.punts.should == 5
        stats.punts_blocked.should == 0
        stats.punt_average_distance.should == 41.6
        stats.punt_net_average.should == 36.6
        stats.punt_returns.should == 2
        stats.punt_return_yards.should == 6
        stats.kickoffs.should == 4
        stats.kickoffs_in_endzone.should == 2
        stats.kickoffs_touchback.should == 1
        stats.kickoff_returns.should == 1
        stats.kickoff_return_yards.should == 27
        stats.penalties.should == 6
        stats.penalty_yards.should == 60
        stats.fumbles.should == 2
        stats.fumbles_lost.should == 1
        stats.time_of_possession.should == 1947
        stats.rushing_tds.should == 0
        stats.passing_tds.should == 0
        stats.other_tds.should == 0
        stats.xp_attempts.should == 0
        stats.xp_conversions.should == 0
        stats.xp_blocked.should == 0
        stats.fg_attempts.should == 5
        stats.fg_conversions.should == 4
        stats.fg_blocked.should == 0
        stats.goal_to_go_attempts.should == 2
        stats.goal_to_go_successes.should == 0
        stats.red_zone_attempts.should == 4
        stats.red_zone_successes.should == 0
        stats.safeties.should == 0
    end
end
