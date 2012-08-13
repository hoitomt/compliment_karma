class Bank
	base_uri = "https://sandbox-api.bancbox.com/BBXPortRest"

	def self.create_client
		RestClient.post "https://sandbox-api.bancbox.com/BBXPortRest/createClient", 
                create_client_payload.to_json, 
                :content_type => :json, 
                :accept => :json
	end

	def self.pay_by_credit_card
		puts collect_funds_payload.to_json
		RestClient.post "https://sandbox-api.bancbox.com/BBXPortRest/collectFunds", 
                collect_funds_payload.to_json, 
                :content_type => :json, 
                :accept => :json
	end

	def self.api_key
		"847eba7c34fe568ff59fd647ca946af7"
	end

	def self.secret
		"1d46269eb3ed713be54051279b818e87"
	end

	def self.subscriber_id
		202492
	end

	def self.collect_funds_payload
		{
	    "authentication" => {
	      "apiKey" => api_key,
	      "secret" => secret
	    },
	    "subscriberId" => subscriber_id,
	    "method"  => "creditcard",
	    "source" => {
	      # "account" => {
	      #   "bancBoxId" => ? ,
	      #   "subscriberReferenceId"  => "?"
	      # },
       #  "linkedExternalAccount" => {
	      #   "bancBoxId" => ? ,
	      #   "subscriberReferenceId"  => "?"
       #  },
        "newExternalAccount" => {
          # "bankAccount" => {
          #   "routingNumber" => "?",
          #   "accountNumber" => "?",
          #   "holderName" => "?",
          #   "bankAccountType" => "?"
          # },
          "creditCardAccount" => {
            "trackdata" =>"track_this",
            "number" => "1234123412341234",
            "expiryDate" => "01/14",
            "type" => "VISA",
            "name" => "George Mason",
            "cvv" => "567",
            "address" => {
              "line1" => "456 Division St",
              # "line2" => "?",
              "city" => "Eau Claire",
              "state" => "WI",
              "zipcode" => "54701"
            }
          }
        }
	    },
	    "destinationAccount" => {
	      "bancBoxId" => 895393 ,
	      "subscriberReferenceId"  => "#{subscriber_id}"
	    },
	    "items" => [{
	      # "referenceId" => "?",
	      "amount" => 1.00 ,
	      "memo"  => "Test Data",
	      # "scheduleDate" => ""
	    }]
		}
	end

	def self.create_client_payload
		{
	    "authentication" => {
	      "apiKey" => api_key,
	      "secret" => secret
	    },
	    "subscriberId" => subscriber_id,
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
		}
	end

end