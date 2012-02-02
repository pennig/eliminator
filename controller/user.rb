class UserController < Controller
    helper :blue_form

    def login
        @title = "Login"
        if request.post?
            user_login(request.subset(:username, :password))
            answer "/"
        end
    end

    def logout
        user_logout
        redirect_referer
    end

    def profile
        login_required
    end

    def info(user_identifier)
        if user_identifier.to_i > 0
            @user = User[user_identifier.to_i]
        else
            @user = User.where(:username => user_identifier).first
        end
    end

    def register
        @title = "Register"
        if request.post?
            token = register_user
            welcome_email = Mailer.welcome_email(request[:email],token)
            puts welcome_email.inspect
            welcome_email.deliver
        end
    end

    def activate(token)
        user_info = UserInfo.where(:token => token).first
        if not user_info.nil?
            user_info.token = nil
            user_info.save
            user = User[user_info[:user_id]]
            user.active = 1
            user.save
            answer "/user/profile"
        else
            puts "invalid token"
        end
    end

    private

    def register_user
        token = Guid.new.to_s

        $db_connection.transaction do
            user = User.create(
                :username => request[:username],
                :password => request[:password],
                :email => request[:email],
                :created_at => Time.now
            )

            user_info = UserInfo.create(
                :user_id => user.id,
                :token => token
            )
        end

        token
    end

end
