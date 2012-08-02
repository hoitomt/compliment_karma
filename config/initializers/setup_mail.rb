if Rails.env.production?
  config = YAML.load(File.read("#{Rails.root}/config/mailgun.yml"))['production']
elsif Rails.env.test?
  config = YAML.load(File.read("#{Rails.root}/config/mailgun.yml"))['test']
else
  config = YAML.load(File.read("#{Rails.root}/config/mailgun.yml"))['development']
end

ActionMailer::Base.smtp_settings = {
  :port           => config['MAILGUN_SMTP_PORT'], 
  :address        => config['MAILGUN_SMTP_SERVER'],
  :user_name      => config['MAILGUN_SMTP_LOGIN'],
  :password       => config['MAILGUN_SMTP_PASSWORD'],
  :domain         => config['MAILGUN_HOST'],
  :authentication => :plain
}
# ActionMailer::Base.delivery_method = :smtp

# ActionMailer::Base.smtp_settings = {
#   :port           => 587, 
#   :address        => 'smtp.mailgun.org',
#   :user_name      => 'postmaster@app5024011.mailgun.org',
#   :password       => '62jp2h0bmg31',
#   :domain         => 'app5024011.mailgun.org',
#   :authentication => :plain
# }