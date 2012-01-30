require_relative '../../model/connect.rb'
require_relative '../../model/model.rb'
require_relative '../../model/legacy_model.rb'

puts "Building team data..."
require_relative "../team_migration.rb"
puts "Done!"
puts ""

puts "Migrating users..."
require_relative "legacy_users.rb"
puts "Done!"
puts ""

puts "Migrating schedule, stats, results, and spread..."
require_relative "legacy_schedule_and_stats.rb"
puts "Done!"
puts ""

puts "Creating default bet sets..."
BetSet.truncate

User.each do |user|
    BetSet.create(
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
Bet.truncate

LegacyBets.each do |legacy_bet|
    legacy_schedule = LegacyScheduleAndStats.with_sql("SELECT * FROM league WHERE season = :season AND week = :week AND (opponent = :team OR home = :team)", :season=>legacy_bet.season, :week => legacy_bet.week, :team => legacy_bet.teamid)

    legacy_schedule = legacy_schedule.first

    generated_game_id = (legacy_schedule.home+10).to_s+(legacy_schedule.opponent+10).to_s+(legacy_schedule.week+10).to_s+legacy_schedule.season.to_s

    spread = Spread.where(:game_id => generated_game_id).first

    bet_set = BetSet.where(:user_id => legacy_bet.userid).first

    #puts "Migrating bet #{legacy_bet.userid}..."
    bet = Bet.create(
        :created_at => legacy_bet.time,
        :updated_at => legacy_bet.time,
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
User.each do |user|
    bets = Bet.where(:user_id => user.id).join(:game_results, :game_id => :game_id)
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
            #puts "not reverse, final record was #{record[:won]}-#{record[:lost]} for #{user.id} in season #{season}"
        else
            #almost certainly reverse!
            puts "REVERSE, final record was #{record[:won]}-#{record[:lost]} for #{user.id} in season #{season}"
            bet_set =BetSet.where(:user_id => user.id, :survival_pickem => 0, :headsup_ats => 0, :regular_reverse => 1).first
            #create a new bet_set
            if bet_set.nil?
                puts "Creating reverse bet set"
                bet_set = BetSet.create(
                    :user_id => user.id,
                    :group_id => nil,
                    :survival_pickem => 0,
                    :headsup_ats => 0,
                    :regular_reverse => 1,
                    :created_at => Time.now
                )
            else
                puts "Reverse bet set already created"
            end
            Bet.where(:user_id => user.id).filter(:bets__season => season).each do |bet|
                bet.bet_set_id = bet_set.id
                bet.regular_reverse = 1
                bet.save
            end
            puts ""
        end
    end
end
puts "Done!"
puts ""
