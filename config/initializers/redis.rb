# Use MockRedis for testing
unless Rails.env.test?
	uri = URI.parse(ENV["REDISTOGO_URL"])
	$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end