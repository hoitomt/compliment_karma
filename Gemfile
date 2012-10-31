source 'http://rubygems.org'

gem 'rails', '3.1.8'
gem 'thin', '1.3.1'
gem 'pg', '0.13.2'
gem 'bcrypt-ruby', '3.0.1', :require => "bcrypt"
gem 'jquery-rails'
gem 'client_side_validations', '3.1.4'
gem 'newrelic_rpm'
gem 'marginalia', "~> 1.1.0"
gem 'restful_metrics'
gem 'rack-mini-profiler'
gem 'redis'
gem 'tire'

# Email - HTTP to mailgun and Bancbox
gem 'rest-client', '1.6.7'
gem 'mailgun-rails', "~> 0.1.1"

# Metrics
gem 'json'
gem 'em-http-request'

# Photo Support
gem 'paperclip', '~>3.0.2'
gem 'aws-sdk', '1.4.1'

# URL Shortener
gem 'url_shortener'

group :development do
	gem 'rspec-rails', '2.6.1'
  gem 'bullet'
end

group :test do
  # Pretty printed test output
	gem 'rspec-rails', '2.6.1'
	# gem 'webrat', '0.7.1'
  gem 'capybara'
  gem 'launchy'
	gem 'spork', '0.9.0'
  gem 'turn', '0.8.2', :require => false
	gem 'factory_girl_rails', '~> 3.0'
  gem 'mock_redis'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-ui-rails'
end
