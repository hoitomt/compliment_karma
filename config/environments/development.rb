Ck::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  # config.action_mailer.delivery_method = :test
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => "localhost:3000" }
  # config.action_mailer.default_url_options = { :host => "ck-dev.herokuapp.com" }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  # config.assets.debug = false # Use for IE testing only

  # Configure Mailgun to use http, rather than smtp
  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.mailgun_settings = {
      :api_key  => 'key-1ed8ophkrawc5969zsvmff02w1f0fiv2',
      :api_host => 'ck-local.mailgun.org'
  }

  # Reposition Mini-Profiler
  Rack::MiniProfiler.config.position = 'right'

  # Redis - created a Redis to Go instance specifically for local development
  ENV["REDISTOGO_URL"] = 'redis://hoitomt:124f63476172c052815d93d14915c6db@clingfish.redistogo.com:9104/' 

end
