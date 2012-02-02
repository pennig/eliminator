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
        @title = user.username
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
            @user = User.new(
                :username => request[:username],
                :password => request[:password],
                :email => request[:email],
                :created_at => Time.now
            )
            errors = @user.validate
            if request[:password].nil? or request[:password].empty?
                errors << "Password is required"
            end
            if request[:password] != request[:repeat_password]
                errors << "Passwords don't match"
            end
            if not errors.empty?
                flash[:message] = errors[0]
            else
                flash.delete(:message)
                token = register_user(@user)
                welcome_email = Mailer.welcome_email(request[:email],token)
                puts welcome_email.inspect
                welcome_email.deliver
                redirect UserController.r(:registered)
            end
        else
            @user = OpenStruct.new
        end
    end

    def registered
        @title = "Awaiting Activation"
    end

    def activate(token)
        user_info = UserInfo.where(:token => token).first
        if not user_info.nil?
            user_info.token = nil
            user_info.save
            user = User[user_info[:user_id]]
            user.active = 1
            user.save
            flash[:message] = "Account Activated!"
            answer "/user/profile"
        else
            @title = "Activation Failed"
        end
    end

    private

    def register_user(new_user)
        token = Guid.new.to_s

        $db_connection.transaction do
            new_user.save

            user_info = UserInfo.create(
                :user_id => new_user.id,
                :token => token
            )
        end

        token
    end

end
