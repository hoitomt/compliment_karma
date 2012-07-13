### Instructions
#    gem install em-http-request
#    ruby dashku_5000364809b5b4263102ca7c.rb
#
# => Maps to Big Number for New Users

require "rubygems"
require "json"
require "em-http-request"

data = JSON.parse('{
  "bigNumber": 1,
  "_id": "5000364809b5b4263102ca7c",
  "apiKey": "f01afab7-b31b-4f31-8516-f5150bee979d"
}')

EventMachine.run {
  http = EventMachine::HttpRequest.new("http://176.58.100.203/api/transmission").post :body => data
  http.callback {
    EventMachine.stop
  }
}

# Note - you will notice that the API url is different to the main url.
# I've been experiencing DNS/latency problems with making the API call through
# to the main sitem so I've used this ip address instead. 
#
# Paul Jensen