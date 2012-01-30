class Team
    def record(season)
        game_data = self.db[:schedule].join(:game_results, :game_id => :game_id).where( {:home_team_id => self.id} | {:away_team_id => self.id}, :season => season)

        won_lost(game_data)
    end

    def full_record(season)
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
            :overall => won_lost(game_data),
            :nfc => {
                :overall => won_lost(game_data.where(:ot__conference => "NFC")),
                :north => won_lost(game_data.where(:ot__conference => "NFC").where(:ot__division => "North")),
                :south => won_lost(game_data.where(:ot__conference => "NFC").where(:ot__division => "South")),
                :east => won_lost(game_data.where(:ot__conference => "NFC").where(:ot__division => "East")),
                :west => won_lost(game_data.where(:ot__conference => "NFC").where(:ot__division => "West"))
            },
            :afc => {
                :overall => won_lost(game_data.where(:ot__conference => "AFC")),
                :north => won_lost(game_data.where(:ot__conference => "AFC").where(:ot__division => "North")),
                :south => won_lost(game_data.where(:ot__conference => "AFC").where(:ot__division => "South")),
                :east => won_lost(game_data.where(:ot__conference => "AFC").where(:ot__division => "East")),
                :west => won_lost(game_data.where(:ot__conference => "AFC").where(:ot__division => "West"))
            }
        }
    end

    private

    def won_lost(game_data)
        {
            :won => game_data.where(:winning_team_id => self.id).count,
            :lost => game_data.where(~:winning_team_id => self.id).where(~:winning_team_id => 0).count,
            :tied => game_data.where(:winning_team_id => nil).count
        }
    end
end

