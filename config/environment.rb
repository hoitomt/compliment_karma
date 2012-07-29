# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ck::Application.initialize!

Ck::Application.configure do
  # config.action_mailer.delivery_method = :smtp

  # Configure Mailgun to use http, rather than smtp
  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.mailgun_settings = {
      :api_key  => 'key-0-zv0demvph1krkk9ctbws9vd17xsyb5',
      :api_host => 'app5024011.mailgun.org'
  }

end