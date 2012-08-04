class Metrics

	@@app_name = 'app6296184@heroku.com'
	def self.new_metric(type)
		RestfulMetrics::Client.add_metric(@@app_name, type, 1)
	end

	def self.new_invitation
		new_metric("new_invitation")
	end

	def self.new_user
		new_metric("new_user")
	end

	def self.new_compliment
		new_metric("new_compliment")
	end

end