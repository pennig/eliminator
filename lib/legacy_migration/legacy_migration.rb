require_relative 'db/connect.rb'
require_relative 'db/model.rb'
require_relative '../db/connect.rb'
require_relative '../db/model.rb'

puts "Migrating users..."
$db_connection.run "ALTER TABLE users MODIFY COLUMN id INT UNSIGNED NOT NULL"
$db_connection.alter_table(:users) do
    drop_constraint(:PRIMARY,:type => :primary_key)
end
#force it to reload the model
class Users < Sequel::Model(:users)
    self.db = $db_connection
end

LegacyUsers.order(:userid).each do |legacy_user|
    #puts "Migrating user #{legacy_user.name}..."
    if legacy_user.active == "1"
        active = 1
    else
        active = 0
    end

    begin
    user = Users.create(
        :id => legacy_user.userid,
        :created_at => Time.now,
        :username => legacy_user.name,
        :old_password => legacy_user.password,
        :password => nil,
        :email => legacy_user.email,
        :active => active
    )

    UserInfo.create(
        :user_id => user.id,
        :token => nil,
        :time_zone => legacy_user.timezone,
        :email_reminder => legacy_user.emailreminder
    )
    rescue Sequel::DatabaseError => e
        puts e
    end

end
$db_connection.alter_table(:users) do
    add_primary_key([:id])
end
$db_connection.run "ALTER TABLE users MODIFY COLUMN id INT UNSIGNED NOT NULL AUTO_INCREMENT"
$db_connection.run "ALTER TABLE users AUTO_INCREMENT=#{LegacyUsers.order(:userid).last.userid+1}"
puts "Done!"
puts ""

puts "Migrating teams..."
LegacyTeams.order(:teamid).each do |legacy_team|
    Teams.create(
        :name => legacy_team.name
    )
end
puts "Done!"
puts ""

puts "Migrating schedule, stats, results, and spread..."
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
        winning_team_id = 0
    end

    #puts "Migrating game results #{generated_game_id}..."
    game_results = GameResults.create(
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
        :total_drives => legacy_schedule.htotaldrives, #no longer available
        :average_drive_start => legacy_schedule.hdrivestart, #no longer available
        :created_at => Time.now,
        :updated_at => Time.now
    )

    #puts "Migrating game stats #{generated_game_id} (away)..."
    away_game_stats = GameStats.create(
        :game_id => generated_game_id,
        :team_id => legacy_schedule.opponent,
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
        :total_drives => legacy_schedule.ototaldrives, #no longer available
        :average_drive_start => legacy_schedule.odrivestart, #no longer available
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
puts "Done!"
puts ""

puts "Creating default bet sets..."
Users.each do |user|
    BetSets.create(
        :user_id => user.id,
        :group_id => nil,
        :survival_pickem => 0,
        :headsup_ats => 0,
        :regular_reverse => 0,
        :created_at => Time.now
    )
end
puts "Done!"
puts ""

puts "Migrating bets..."
LegacyBets.each do |legacy_bet|
    legacy_schedule = LegacyScheduleAndStats.with_sql("SELECT * FROM league WHERE season = :season AND week = :week AND (opponent = :team OR home = :team)", :season=>legacy_bet.season, :week => legacy_bet.week, :team => legacy_bet.teamid)

    legacy_schedule = legacy_schedule.first

    generated_game_id = (legacy_schedule.home+10).to_s+(legacy_schedule.opponent+10).to_s+(legacy_schedule.week+10).to_s+legacy_schedule.season.to_s

    spread = Spread.where(:game_id => generated_game_id).first

    bet_set = BetSets.where(:user_id => legacy_bet.userid).first

    #puts "Migrating bet #{legacy_bet.userid}..."
    bet = Bets.create(
        :created_at => Time.now,
        :updated_at => Time.now,
        :user_id => legacy_bet.userid,
        :season => legacy_bet.season,
        :week_number => legacy_bet.week,
        :week_type => 'REG',
        :game_id => generated_game_id,
        :team_id => legacy_bet.teamid,
        :spread_id => spread.id,
        :bet_set_id => bet_set.id,
        :survival_pickem => 0,
        :headsup_ats => 0,
        :regular_reverse => 0
    )
end
puts "Done!"
puts ""

puts "Trying to determine which users were probably attempting reverse..."
Users.each do |user|
    bets = Bets.where(:user_id => user.id).join(:game_results, :game_id => :game_id)
    (2004..2011).each do |season|
        record = { :won => 0, :lost => 0 }
        bets.filter(:bets__season => season).each do |bet|
            if bet[:team_id] == bet[:winning_team_id]
                record[:won] += 1
            else
                record[:lost] += 1
            end
        end
        if record[:won] + record[:lost] > 17
            puts "more than 18 bets for user #{user.id} in #{season}"
        end

        if record[:won]+record[:lost] == 0
            #ignore it
        elsif record[:won] > record[:lost] or record[:won] - record[:lost] > -2 or record[:won] + record[:lost] < 8
            puts "not reverse, final record was #{record[:won]}-#{record[:lost]} for #{user.id} in season #{season}"
        else
            #almost certainly reverse!
            puts "REVERSE, final record was #{record[:won]}-#{record[:lost]} for #{user.id} in season #{season}"
            puts ""
            bet_set =BetSets.where(:user_id => user.id, :survival_pickem => 0, :headsup_ats => 0, :regular_reverse => 1).first
            #create a new bet_set
            if bet_set.nil?
                bet_set = BetSets.create(
                    :user_id => user.id,
                    :group_id => nil,
                    :survival_pickem => 0,
                    :headsup_ats => 0,
                    :regular_reverse => 1,
                    :created_at => Time.now
                )
            end
            Bets.where(:user_id => user.id).filter(:bets__season => season).each do |bet|
                bet.bet_set_id = bet_set.id
                bet.save
            end
        end
    end
end
puts "Done!"
puts ""
