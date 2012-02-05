require_relative '../model/connect.rb'
require_relative '../model/model.rb'
require_relative '../classes/boxscoreparser.rb'

GameStats.truncate

def save_results(game_id,team_id,stats)
    hash = stats.marshal_dump.merge(:game_id => game_id, :team_id => team_id, :created_at => Time.now, :updated_at => Time.now)
    GameStats.create(hash)
end

Schedule.order(:game_id.asc).each do |game|
    puts game.game_id
    box_score = BoxScoreParser.new(game.game_id)
    home = box_score.stats_for("home")
    save_results(game.game_id,game.home_team_id,home)
    away = box_score.stats_for("away")
    save_results(game.game_id,game.away_team_id,away)
end
