require_relative '../../model/connect.rb'
require_relative '../../model/model.rb'
require_relative '../../model/legacy_model.rb'

Schedule.truncate
GameResult.truncate
GameStats.truncate
Spread.truncate

LegacyScheduleAndStats.each do |legacy_schedule|

    generated_game_id = (legacy_schedule.home+10).to_s+(legacy_schedule.opponent+10).to_s+(legacy_schedule.week+10).to_s+legacy_schedule.season.to_s

    if Schedule.filter(:game_id => generated_game_id).count > 0
        puts "This game_id is not unique: #{generated_game_id}"
        puts "Tried to generate it for #{legacy_schedule.inspect}"
        exit
    end

    #puts "Migrating schedule #{generated_game_id}..."
    schedule = Schedule.create(
        :game_id => generated_game_id,
        :season => legacy_schedule.season,
        :week_number => legacy_schedule.week,
        :week_type => "REG",
        :home_team_id => legacy_schedule.home,
        :away_team_id => legacy_schedule.opponent,
        :game_time => Time.at(legacy_schedule.gametime)
    )

    if legacy_schedule.homescore > legacy_schedule.oppscore
        winning_team_id = schedule.home_team_id
    elsif legacy_schedule.homescore < legacy_schedule.oppscore
        winning_team_id = schedule.away_team_id
    else
        winning_team_id = nil
    end

    #puts "Migrating game results #{generated_game_id}..."
    game_results = GameResult.create(
        :game_id => generated_game_id,
        :home_score => legacy_schedule.homescore,
        :away_score => legacy_schedule.oppscore,
        :game_clock => "0:00",
        :quarter => 4,
        :status => "FINAL",
        :winning_team_id => winning_team_id,
        :updated_at => Time.now
    )

    #puts "Migrating game stats #{generated_game_id} (home)..."
    home_game_stats = GameStats.create(
        :game_id => generated_game_id,
        :team_id => legacy_schedule.home,
        :points => legacy_schedule.homescore,
        :turnovers => legacy_schedule.hturnover,
        :rushing_yards => legacy_schedule.hrush,
        :rushing_attempts => legacy_schedule.hrushes,
        :passing_yards => legacy_schedule.hpass,
        :passing_attempts => legacy_schedule.hpassatt,
        :passing_completions => legacy_schedule.hpasscomp,
        :sacks => legacy_schedule.hsacks,
        :sack_yards_lost => legacy_schedule.hyardslost,
        :interceptions_thrown => legacy_schedule.hints,
        :interception_return_yards => legacy_schedule.hintreturn,
        :rushing_1st_downs => legacy_schedule.hrushfirst,
        :passing_1st_downs => legacy_schedule.hpassfirst,
        :penalty_1st_downs => legacy_schedule.hpenaltyfirst,
        :third_down_attempts => legacy_schedule.h3rdatt,
        :third_down_conversions => legacy_schedule.h3rdsuccess,
        :fourth_down_attempts => legacy_schedule.h4thatt,
        :fourth_down_conversions => legacy_schedule.h4thsuccess,
        :punts => legacy_schedule.hpunts,
        :punt_average_distance => legacy_schedule.hpuntavg,
        :punt_returns => legacy_schedule.hpreturn,
        :kickoffs => legacy_schedule.hkickoffs,
        :kickoff_returns => legacy_schedule.hkreturn,
        :penalties => legacy_schedule.hpenalties,
        :penalty_yards => legacy_schedule.hpenaltyyards,
        :fumbles => legacy_schedule.hfumbles,
        :fumbles_lost => legacy_schedule.hfumbleslost,
        :time_of_possession => legacy_schedule.htimeofpos,
        :rushing_tds => legacy_schedule.hrushtd,
        :passing_tds => legacy_schedule.hpasstd,
        :other_tds => legacy_schedule.hothertd,
        :xp_attempts => legacy_schedule.hxtraatt,
        :xp_conversions => legacy_schedule.hxtramade,
        :fg_attempts => legacy_schedule.hfgatt,
        :fg_conversions => legacy_schedule.hfgmade,
        :goal_to_go_attempts => legacy_schedule.hgoalatt,
        :goal_to_go_successes => legacy_schedule.hgoalsuccess,
        :red_zone_attempts => legacy_schedule.hredatt,
        :red_zone_successes => legacy_schedule.hredsuccess,
        :safeties => legacy_schedule.hsafety,
        :created_at => Time.now,
        :updated_at => Time.now
    )

    #puts "Migrating game stats #{generated_game_id} (away)..."
    away_game_stats = GameStats.create(
        :game_id => generated_game_id,
        :team_id => legacy_schedule.opponent,
        :points => legacy_schedule.oppscore,
        :turnovers => legacy_schedule.oturnover,
        :rushing_yards => legacy_schedule.orush,
        :rushing_attempts => legacy_schedule.orushes,
        :passing_yards => legacy_schedule.opass,
        :passing_attempts => legacy_schedule.opassatt,
        :passing_completions => legacy_schedule.opasscomp,
        :sacks => legacy_schedule.osacks,
        :sack_yards_lost => legacy_schedule.oyardslost,
        :interceptions_thrown => legacy_schedule.oints,
        :interception_return_yards => legacy_schedule.ointreturn,
        :rushing_1st_downs => legacy_schedule.orushfirst,
        :passing_1st_downs => legacy_schedule.opassfirst,
        :penalty_1st_downs => legacy_schedule.openaltyfirst,
        :third_down_attempts => legacy_schedule.o3rdatt,
        :third_down_conversions => legacy_schedule.o3rdsuccess,
        :fourth_down_attempts => legacy_schedule.o4thatt,
        :fourth_down_conversions => legacy_schedule.o4thsuccess,
        :punts => legacy_schedule.opunts,
        :punt_average_distance => legacy_schedule.opuntavg,
        :punt_returns => legacy_schedule.opreturn,
        :kickoffs => legacy_schedule.okickoffs,
        :kickoff_returns => legacy_schedule.okreturn,
        :penalties => legacy_schedule.openalties,
        :penalty_yards => legacy_schedule.openaltyyards,
        :fumbles => legacy_schedule.ofumbles,
        :fumbles_lost => legacy_schedule.ofumbleslost,
        :time_of_possession => legacy_schedule.otimeofpos,
        :rushing_tds => legacy_schedule.orushtd,
        :passing_tds => legacy_schedule.opasstd,
        :other_tds => legacy_schedule.oothertd,
        :xp_attempts => legacy_schedule.oxtraatt,
        :xp_conversions => legacy_schedule.oxtramade,
        :fg_attempts => legacy_schedule.ofgatt,
        :fg_conversions => legacy_schedule.ofgmade,
        :goal_to_go_attempts => legacy_schedule.ogoalatt,
        :goal_to_go_successes => legacy_schedule.ogoalsuccess,
        :red_zone_attempts => legacy_schedule.oredatt,
        :red_zone_successes => legacy_schedule.oredsuccess,
        :safeties => legacy_schedule.osafety,
        :created_at => Time.now,
        :updated_at => Time.now
    )

    #puts "Migrating spread #{generated_game_id}..."
    spread = Spread.create(
        :game_id => generated_game_id,
        :spread => legacy_schedule.spread,
        :created_at => Time.now
    )
end
