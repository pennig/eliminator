# Define a subclass of Ramaze::Controller holding your defaults for all controllers. Note
# that these changes can be overwritten in sub controllers by simply calling the method
# but with a different value.

class Controller < Ramaze::Controller
    helper :user
    layout :default
    helper :xhtml
    engine :etanni
    helper :stack

    def login_required
        call UserController.r(:login) unless logged_in?
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
require __DIR__('user')
require __DIR__('schedule')
require __DIR__('group')
require __DIR__('team')
require __DIR__('game')
