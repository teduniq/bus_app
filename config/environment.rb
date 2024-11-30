# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# Add sendgrid support
if Rails.env.production?
    ActionMailer::Base.smtp_settings = {
        :user_name => "sendgrid_username",
        :password => "sendgrid_password",
        :domain => "your-domain.com",
        :address => "sendgrid_hostname",
        :port => 3000, # sendgrid_port
        :authentication => :plain,
        :enable_starttls_auto => true
    }
 end