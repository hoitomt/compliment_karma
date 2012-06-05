source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'thin'
gem 'pg'
gem 'heroku'
gem 'bcrypt-ruby', :require => "bcrypt"
gem 'jquery-rails'
gem 'client_side_validations'

# Email - HTTP to mailgun
gem 'rest-client'

# Photo Support
gem 'paperclip', '~>3.0.2'
gem 'aws-sdk'

group :development do
	gem 'rspec-rails', '2.6.1'
end

group :test do
  # Pretty printed test output
	gem 'rspec-rails', '2.6.1'
	gem 'webrat', '0.7.1'
	gem 'spork', '0.9.0'
  gem 'turn', '0.8.2', :require => false
	gem 'factory_girl_rails', '~> 3.0'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end
