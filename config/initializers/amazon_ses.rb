# config = YAML.load(File.read("#{Rails.root}/config/s3.yml"))
# ActionMailer::Base.add_delivery_method :ses, 
#                                        AWS::SimpleEmailService,
#                                        :access_key_id     => config['development']['access_key_id'],
#                                        :secret_access_key => config['development']['secret_access_key']