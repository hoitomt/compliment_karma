class TaskRunner

	# Update compliment types 20120822
	def self.run_task
		add_user_to_redis
	end

	# Initialize the Redis instance with user data
	def self.add_user_to_redis
		users = User.all
		users.each do |u|
			u.add_to_redis
		end
	end

	# Copy the email addresses from User to UserEmail and set to Primary
	def self.user_email
		users = User.all
		account_status_confirmed = AccountStatus.CONFIRMED.id
		users.each do |u|
			confirmed = u.account_status_id == account_status_confirmed ? 'Y' : 'N'
			puts confirmed
			UserEmail.create(:user_id => u.id,
											 :email => u.email,
											 :domain => u.domain,
											 :confirmed => confirmed, 
											 :primary_email => 'Y')
		end
	end

	# Set the compliment type names
	def self.compliment_type
		c = ComplimentType.all
		c[0].update_attributes(:name => "Professional to Professional", 
													 :list_name => "from my PROFESSIONAL to receivers PROFESSIONAL profile")
		c[1].update_attributes(:name => "Professional to Social", 
													 :list_name => "from my PROFESSIONAL to receivers SOCIAL profile")
		c[2].update_attributes(:name => "Social to Professional", 
													 :list_name => "from my SOCIAL to receivers PROFESSIONAL profile")
		c[3].update_attributes(:name => "Social to Social", 
													 :list_name => "from my SOCIAL to receivers SOCIAL profile")
	end
end