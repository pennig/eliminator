# Define a subclass of Ramaze::Controller holding your defaults for all controllers. Note
# that these changes can be overwritten in sub controllers by simply calling the method
# but with a different value.

class Controller < Ramaze::Controller
    helper :user
    layout :default
    helper :xhtml
    engine :etanni
    helper :stack

    def initialize
        @title = "SAS Eliminator"
    end

    def login_required
        call RegisterController.r(:login) unless logged_in?
    end

    def current_season
        2012
    end
    def current_week_type
        "REG"
    end

    def current_week_number
        1
    end

    def controller_name
        self.class.name.gsub("Controller", "").downcase.to_sym
    end

    def build_path
        method_invoked = parse_caller(caller(1).first).last
        if method_invoked == "index"
            "/#{controller_name}/"
        else
            "/#{controller_name}/#{method_invoked}/"
        end
    end

    def parse_caller(at)
        if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
            file   = Regexp.last_match[1]
            line   = Regexp.last_match[2].to_i
            method = Regexp.last_match[3]
            [file, line, method]
        end
    end
end

# Here you can require all your other controllers. Note that if you have multiple
# controllers you might want to do something like the following:
#
#  Dir.glob('controller/*.rb').each do |controller|
#    require(controller)
#  end
#
require __DIR__('main')
require __DIR__('register')
require __DIR__('user')
require __DIR__('schedule')
require __DIR__('group')
require __DIR__('team')
require __DIR__('game')
require __DIR__('ajax_game')
require __DIR__('bet')
require __DIR__('statistics')
require __DIR__('leaderboard')
