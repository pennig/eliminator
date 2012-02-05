#this script should not be needed normally. it exists solely to assist in the migration
#by fixing the fake game_ids to be valid ones by scraping nfl.com and matching them up
#
#in normal circumstances we will be getting game_ids in some other manner when
#initially populating the schedule table

require 'net/http'
require_relative '../model/connect.rb'
require_relative '../model/model.rb'

def name_to_id(name)
    case
        when name == "cardinals" then 1
        when name == "falcons" then 2
        when name == "panthers" then 3
        when name == "bears" then 4
        when name == "cowboys" then 5
        when name == "lions" then 6
        when name == "packers" then 7
        when name == "vikings" then 8
        when name == "saints" then 9
        when name == "giants" then 10
        when name == "eagles" then 11
        when name == "49ers" then 12
        when name == "seahawks" then 13
        when name == "rams" then 14
        when name == "buccaneers" then 15
        when name == "redskins" then 16
        when name == "ravens" then 17
        when name == "bills" then 18
        when name == "bengals" then 19
        when name == "browns" then 20
        when name == "broncos" then 21
        when name == "texans" then 22
        when name == "colts" then 23
        when name == "jaguars" then 24
        when name == "chiefs" then 25
        when name == "dolphins" then 26
        when name == "patriots" then 27
        when name == "jets" then 28
        when name == "raiders" then 29
        when name == "steelers" then 30
        when name == "chargers" then 31
        when name == "titans" then 32
    end
end

week_type = "REG"
(2005..2011).each do |season|
    (1..17).each do |week_number|
        sleep(1)
        puts "http://www.nfl.com/scores/#{season}/#{week_type}#{week_number}"
        begin
            raw_data = Net::HTTP.get(URI("http://www.nfl.com/scores/#{season}/#{week_type}#{week_number}"))
        rescue
            #try again. nfl likes to limit me
            sleep(5)
            raw_data = Net::HTTP.get(URI("http://www.nfl.com/scores/#{season}/#{week_type}#{week_number}"))
        end

        game_data = raw_data.scan(Regexp.new("<a href=\"/gamecenter/([0-9]+)/#{season}/#{week_type}#{week_number}/([a-z0-9]+)@([a-z0-9]+)\" class=\"game-center-link\">"))
        puts game_data.inspect
        game_data.each do |id_and_teams|

            game = Schedule.where(
                :home_team_id => name_to_id(id_and_teams[2]),
                :away_team_id => name_to_id(id_and_teams[1]),
                :season => season,
                :week_type => week_type,
                :week_number => week_number
            ).first
            if game.nil?
                val = { :home_team_id => name_to_id(id_and_teams[2]), :away_team_id => name_to_id(id_and_teams[1]), :season => season, :week_type => week_type, :week_number => week_number }
                puts val.inspect
                exit
            end
            old_game_id = game.game_id
            game.game_id = id_and_teams[0]
            game.save

            Bet.where(:game_id => old_game_id).update(:game_id => id_and_teams[0])
            GameResult.where(:game_id => old_game_id).update(:game_id => id_and_teams[0])
            GameStats.where(:game_id => old_game_id).update(:game_id => id_and_teams[0])
            Spread.where(:game_id => old_game_id).update(:game_id => id_and_teams[0])
        end
    end
end
