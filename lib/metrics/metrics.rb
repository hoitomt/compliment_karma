class Metrics

	@@app_name = 'app6296184@heroku.com'
	def self.send_metric
		RestfulMetrics::Client.add_metric(@@app_name, "impression", 1)

	end

end