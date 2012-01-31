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
end
