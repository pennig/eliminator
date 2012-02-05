class User
    include BCrypt

    one_to_many :owned_groups, :class => Group, :key => :owner_id
    many_to_many :joined_groups, :join_table => :group_members, :class => Group, :left_key => :user_id, :right_key => :group_id
    one_to_one :user_info, :class => UserInfo, :key => :user_id

    def password
        @password ||= Password.new(self.passwd)
    end

    def password=(new_password)
        @password = Password.create(new_password)
        self.passwd = @password
    end

    def validate
        errors = []
        if self.username.nil? or self.username.size < 3
            errors << "Username must be at least three characters"
        end
        if not User.by_username(self.username).nil?
            errors << "That username is already taken!"
        end
        if self.email.nil? or self.email.empty?
            errors << "Email is required"
        end
        return errors
    end

    def self.by_username(username)
        self.where(:username => username).first
    end

    def self.authenticate(hash)
        if hash["username"].nil? or hash["password"].nil?
            raise ArgumentError, "Username/password cannot be nil"
        end
        user = User.where(:username => hash["username"]).first
        if user.nil?
            raise StandardError, "No such user found"
        end
        if not user.active
            raise StandardError, "User has not activated"
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

    #gets the user record very quickly. much faster than the view for a single user
    def record(season=nil)
        sql = "select
           b.user_id,
           b.season,
           sum(case when ((gr.status = 'FINAL') and (gr.winning_team_id = b.team_id) and (b.survival_pickem = 0) and (b.headsup_ats = 0) and (b.regular_reverse = 0)) then 1 else 0 end) AS s_h_reg_won,
           sum(case when ((gr.status = 'FINAL') and ((gr.winning_team_id <> b.team_id) or isnull(gr.winning_team_id)) and (b.survival_pickem = 0) and (b.headsup_ats = 0) and (b.regular_reverse = 0)) then 1 else 0 end) AS s_h_reg_lost,
           sum(case when ((gr.status = 'FINAL') and (gr.winning_team_id is not null) and (gr.winning_team_id <> b.team_id) and (b.survival_pickem = 0) and (b.headsup_ats = 0) and (b.regular_reverse = 1)) then 1 else 0 end) AS s_h_rev_won,
           sum(case when ((gr.status = 'FINAL') and ((gr.winning_team_id = b.team_id) or isnull(gr.winning_team_id)) and (b.survival_pickem = 0) and (b.headsup_ats = 0) and (b.regular_reverse = 1)) then 1 else 0 end) AS s_h_rev_lost,
           sum(case when ((gr.status = 'FINAL') and (gr.winning_team_id = b.team_id) and (b.survival_pickem = 1) and (b.headsup_ats = 0) and (b.regular_reverse = 0)) then 1 else 0 end) AS p_h_reg_won,
           sum(case when ((gr.status = 'FINAL') and ((gr.winning_team_id <> b.team_id) or isnull(gr.winning_team_id)) and (b.survival_pickem = 1) and (b.headsup_ats = 0) and (b.regular_reverse = 0)) then 1 else 0 end) AS p_h_reg_lost,
           sum(case when ((gr.status = 'FINAL') and (gr.winning_team_id is not null) and (gr.winning_team_id <> b.team_id) and (b.survival_pickem = 1) and (b.headsup_ats = 0) and (b.regular_reverse = 1)) then 1 else 0 end) AS p_h_rev_won,
           sum(case when ((gr.status = 'FINAL') and ((gr.winning_team_id = b.team_id) or isnull(gr.winning_team_id)) and (b.survival_pickem = 1) and (b.headsup_ats = 0) and (b.regular_reverse = 1)) then 1 else 0 end) AS p_h_rev_lost,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) < s.spread) and (b.survival_pickem = 0) and (b.headsup_ats = 1) and (b.regular_reverse = 0)) then 1 else 0 end) AS s_a_reg_won,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) > s.spread) and (b.survival_pickem = 0) and (b.headsup_ats = 1) and (b.regular_reverse = 0)) then 1 else 0 end) AS s_a_reg_lost,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) = s.spread) and (b.survival_pickem = 0) and (b.headsup_ats = 1) and (b.regular_reverse = 0)) then 1 else 0 end) AS s_a_reg_push,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) > s.spread) and (b.survival_pickem = 0) and (b.headsup_ats = 1) and (b.regular_reverse = 1)) then 1 else 0 end) AS s_a_rev_won,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) < s.spread) and (b.survival_pickem = 0) and (b.headsup_ats = 1) and (b.regular_reverse = 1)) then 1 else 0 end) AS s_a_rev_lost,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) = s.spread) and (b.survival_pickem = 0) and (b.headsup_ats = 1) and (b.regular_reverse = 1)) then 1 else 0 end) AS s_a_rev_push,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) < s.spread) and (b.survival_pickem = 1) and (b.headsup_ats = 1) and (b.regular_reverse = 0)) then 1 else 0 end) AS p_a_reg_won,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) > s.spread) and (b.survival_pickem = 1) and (b.headsup_ats = 1) and (b.regular_reverse = 0)) then 1 else 0 end) AS p_a_reg_lost,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) = s.spread) and (b.survival_pickem = 1) and (b.headsup_ats = 1) and (b.regular_reverse = 0)) then 1 else 0 end) AS p_a_reg_push,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) > s.spread) and (b.survival_pickem = 1) and (b.headsup_ats = 1) and (b.regular_reverse = 1)) then 1 else 0 end) AS p_a_rev_won,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) < s.spread) and (b.survival_pickem = 1) and (b.headsup_ats = 1) and (b.regular_reverse = 1)) then 1 else 0 end) AS p_a_rev_lost,
           sum(case when ((gr.status = 'FINAL') and ((gr.away_score - gr.home_score) = s.spread) and (b.survival_pickem = 1) and (b.headsup_ats = 1) and (b.regular_reverse = 1)) then 1 else 0 end) AS p_a_rev_push
        from bets b
        join game_results gr on gr.game_id = b.game_id
        join spread s on b.spread_id = s.id
        where user_id = ?"
        if season.nil?
            sql += " group by season"
        else
            sql += " and season = ?"
        end
        self.db[sql,self.id,season]
    end
end
