class User
    include BCrypt

    one_to_many :owned_groups, :class => Group, :key => :owner_id
    many_to_many :joined_groups, :join_table => :group_members, :class => Group, :left_key => :user_id, :right_key => :group_id

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
