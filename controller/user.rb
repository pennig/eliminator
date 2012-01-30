class UserController < Controller
    helper :user, :blue_form

    def login
        @title = "Login"
        if request.post?
            user_login(request.subset(:username, :password))
            redirect MainController.r(:'')
        end
    end

    def logout
        user_logout
        redirect_referer
    end
end
