# require 'net/http'
require 'rubygems'
require 'json'
# require 'rest_client'

payload = {
	  "authentication" => {
	    "apiKey" => "847eba7c34fe568ff59fd647ca946af7",
	    "secret" => "1d46269eb3ed713be54051279b818e87"
	  },
	  "subscriberId" => 202492,
	  "referenceId" => "ck_test",
	  "firstName" => "Test",
	  "lastName" => "Account",
	  "middleInitial" => "J",
	  "ssn" => "111-22-3344",
	  "dob" => "1970-01-15",
	  "address" => {
	    "line1" => "123 Main St",
	    # "line2" => "",
	    "city" => "Eau Claire",
	    "state" => "WI",
	    "zipcode" => "54701"
	  },
	  "homePhone" => "1112223333",
	  # "mobilePhone" => "",
	  # "workPhone" => "",
	  "email" => "test@complimentkarma.com"
	  # "username" => ""
	}.to_json
	
RestClient.post "https://sandbox-api.bancbox.com/BBXPortRest/createClient", 
                payload.to_json, 
                :content_type => :json, 
                :accept => :json


# 
# host = "https://sandbox-api.bancbox.com/BBXPortRest/"
# post_ws = "/createClient"
# 
# req = Net::HTTP::Post.new(post_ws, initheader = {'Content-Type' => 'application/json'})
# req.body = payload
# response = Net::HTTP.new(host).start {|http| http.request(req)}
# puts "Response #{response.code} #{response.message}:#{response.body}"
