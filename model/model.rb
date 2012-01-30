require 'rubygems'
require 'sequel'
require 'bcrypt'

class BetSet < Sequel::Model(:bet_sets)
    self.db = $db_connection
end

class Bet < Sequel::Model(:bets)
    self.db = $db_connection
end

class GameResult < Sequel::Model(:game_results)
    self.db = $db_connection
end

class GameStats < Sequel::Model(:game_stats)
    self.db = $db_connection
end

class GroupFeature < Sequel::Model(:group_features)
    self.db = $db_connection
end

class Group < Sequel::Model(:groups)
    self.db = $db_connection
end

class OverUnder < Sequel::Model(:over_under)
    self.db = $db_connection
end

class PowerRankingAlgorithm < Sequel::Model(:power_ranking_algorithms)
    self.db = $db_connection
end

class Team < Sequel::Model(:teams)
    self.db = $db_connection

    def record(season)
        game_data = self.db[:schedule].join(:game_results, :game_id => :game_id).where( {:home_team_id => self.id} | {:away_team_id => self.id}, :season => season)

        won_lost(game_data)
    end

    def division_record(season)
        game_data = self.db[:schedule]
            .select(
                :game_id.qualify(:game_results).as(:game_id),
                :home_score.qualify(:game_results).as(:home_score),
                :away_score.qualify(:game_results).as(:away_score),
                :winning_team_id.qualify(:game_results).as(:winning_team_id),
                :season.qualify(:schedule).as(:season),
                :week_number.qualify(:schedule).as(:week_number),
                :id.qualify(:ot).as(:opp_id),
                :conference.qualify(:ot).as(:opp_conference),
                :division.qualify(:ot).as(:opp_division),
                :conference.qualify(:mt).as(:my_conference),
                :division.qualify(:mt).as(:my_division)
            )
            .join(:game_results, :game_id => :game_id)
            .join(:teams.as(:ot), {:ot__id => :schedule__home_team_id} | {:ot__id => :schedule__away_team_id})
            .join(:teams.as(:mt), :id => self.id)
            .where( {:home_team_id => self.id} | {:away_team_id => self.id}, :season => season, ~:ot__id => self.id)

        {
            :conference => won_lost(game_data.where(:mt__conference => :ot__conference)),
            :division => won_lost(game_data.where(:mt__conference => :ot__conference).where(:mt__division => :ot__division))
        }
    end

    private

    def won_lost(game_data)
        {
            :won => game_data.where(:winning_team_id => self.id).count,
            :lost => game_data.where(~:winning_team_id => self.id).where(~:winning_team_id => 0).count,
            :tied => game_data.where(:winning_team_id => 0).count
        }
    end
end

class Schedule < Sequel::Model(:schedule)
    self.db = $db_connection

    many_to_one :home_team, :class => Team, :key => :home_team_id
    many_to_one :away_team, :class => Team, :key => :away_team_id
    one_to_one :home_stats, :class => GameStats, :key => [:game_id, :team_id], :primary_key => [:game_id, :home_team_id]
    one_to_one :away_stats, :class => GameStats, :key => [:game_id, :team_id], :primary_key => [:game_id, :away_team_id]
    one_to_one :results, :class => GameResult, :key => :game_id, :primary_key => :game_id
end

class Spread < Sequel::Model(:spread)
    self.db = $db_connection
end

class UserInfo < Sequel::Model(:user_info)
    self.db = $db_connection
end

class User < Sequel::Model(:users)
    include BCrypt
    self.db = $db_connection

    def password
        @password ||= Password.new(self.passwd)
    end

    def password=(new_password)
        @password = Password.create(new_password)
        self.passwd = @password
    end

    def self.authenticate(hash)
        if hash["username"].nil? or hash["password"].nil?
            raise ArgumentError, "Username/password cannot be nil"
        end
        user = User.where(:username => hash["username"]).first
        if user.nil?
            raise StandardError, "No such user found"
        end

        if not user.old_password.nil?
            if check_old_password(user,hash["password"])
                return user
            end
        else
            if user.password == hash["password"]
                return user
            end
        end

        false
    end

    def self.check_old_password(user,pass)
        if user.old_password == pass.crypt("randomsalt")
            user.password = pass
            user.old_password = nil
            user.save
            return true
        else
            return false
        end
    end
end
