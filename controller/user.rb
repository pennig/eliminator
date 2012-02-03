class UserController < Controller
    helper :blue_form

    def profile
        login_required
        @title = user.username
    end

    def info(user_identifier=nil)
        if user_identifier.to_i > 0
            @user = User[user_identifier.to_i]
        else
            @user = User.where(:username => user_identifier).first
        end
        @bet_record = VBetRecord.where(:user_id => @user.id)
    end

end
