# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ck::Application.initialize!

Ck::Application.configure do
  config.action_mailer.delivery_method = :smtp
end