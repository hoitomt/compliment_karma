class DashkuMetrics

	def self.send_new_user
		if Rails.env.production?
			data = JSON.parse('{
			  "bigNumber": 1,
			  "_id": "500055de09b5b4263102d0b8",
			  "apiKey": "f01afab7-b31b-4f31-8516-f5150bee979d"
			}')
		else
			data = JSON.parse('{
			  "bigNumber": 1,
			  "_id": "5000364809b5b4263102ca7c",
			  "apiKey": "f01afab7-b31b-4f31-8516-f5150bee979d"
			}')
		end
		send_to_dashku(data)
	end

	def self.send_new_compliment
		if Rails.env.production?
			data = JSON.parse('{
			  "bigNumber": 1,
			  "_id": "500054d009b5b4263102d069",
			  "apiKey": "f01afab7-b31b-4f31-8516-f5150bee979d"
			}')
		else
			data = JSON.parse('{
			  "bigNumber": 1,
			  "_id": "500032a609b5b4263102c9e8",
			  "apiKey": "f01afab7-b31b-4f31-8516-f5150bee979d"
			}')
		end
		send_to_dashku(data)
	end

	private
		def self.send_to_dashku(data)

			EventMachine.run {
			  http = EventMachine::HttpRequest.new("http://176.58.100.203/api/transmission").post :body => data
			  http.callback {
			    EventMachine.stop
			  }
			}
		end

end
