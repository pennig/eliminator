class UserController < Controller
    helper :blue_form

    def login
        @title = "Login"
        if request.post?
            user_login(request.subset(:username, :password))
            #redirect MainController.r(:'')
            redirect_referer
        end
    end

    def logout
        user_logout
        redirect_referer
    end
end
