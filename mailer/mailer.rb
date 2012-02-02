require 'action_mailer'
require 'guid'

ActionMailer::Base.raise_delivery_errors = true
#ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.delivery_method = :test
ActionMailer::Base.smtp_settings = {
    :address   => "smtp.gmail.com",
    :port      => 587,
    :domain    => "somedomain.com",
    :authentication => :plain,
    :user_name      => "guy@somedomain.com",
    :password       => "mypassword",
    :enable_starttls_auto => true
}
ActionMailer::Base.view_paths= File.dirname(__FILE__)

class Mailer < ActionMailer::Base
    def welcome_email(to,token)
        @token = hash

        mail(
            :to      => to,
            :from    => "no-reply@saseliminator.com",
            :subject => "Welcome to SAS Eliminator!"
        ) do |format|
            #format.text
            format.html
        end
    end
end
