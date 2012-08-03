class Bank
	def self.connect
		url = 'https://sandbox-api.bancbox.com/BBXPortRest/'
	end

	def self.request
		{
	    "authentication": {
	      "apiKey": "847eba7c34fe568ff59fd647ca946af7",
	      "secret": "1d46269eb3ed713be54051279b818e87"
	    },
	    "subscriberId": 202492,
	    "method" : "creditcard",
	    "source": {
	      # "account": {
	      #   "bancBoxId": ? ,
	      #   "subscriberReferenceId" : "?"
	      # },
       #  "linkedExternalAccount": {
	      #   "bancBoxId": ? ,
	      #   "subscriberReferenceId" : "?"
       #  },
        "newExternalAccount": {
          # "bankAccount": {
          #   "routingNumber": "?",
          #   "accountNumber": "?",
          #   "holderName": "?",
          #   "bankAccountType": "?"
          # },
          "creditCardAccount": {
            "trackdata":"?",
            "number": "?",
            "expiryDate": "?",
            "type": "?",
            "name": "?"
            "cvv": "?",
            "address": {
              "line1": "?",
              "line2": "?",
              "city": "?",
              "state": "?",
              "zipcode": "?"
            }
          }
        }
	    },
	    "destinationAccount": {
	      "bancBoxId": ? ,
	      "subscriberReferenceId" : "?"
	    },
	    "items": [{
	      "referenceId": "?",
	      "amount": 1.00 ,
	      "memo" : "Test Data",
	      "scheduleDate": "?"
	    }]
		}
	end

	# invalid, JSON format
	# def self.request
	# 	{
	#     "authentication": {
	#       "apiKey": "847eba7c34fe568ff59fd647ca946af7",
	#       "secret": "1d46269eb3ed713be54051279b818e87"
	#     },
	#     "subscriberId": 202492,
	#     "method" : "creditcard",
	#     "source": {
	#       # "account": {
	#       #   "bancBoxId": ? ,
	#       #   "subscriberReferenceId" : "?"
	#       # },
 #       #  "linkedExternalAccount": {
	#       #   "bancBoxId": ? ,
	#       #   "subscriberReferenceId" : "?"
 #       #  },
 #        "newExternalAccount": {
 #          # "bankAccount": {
 #          #   "routingNumber": "?",
 #          #   "accountNumber": "?",
 #          #   "holderName": "?",
 #          #   "bankAccountType": "?"
 #          # },
 #          "creditCardAccount": {
 #            "trackdata":"?",
 #            "number": "?",
 #            "expiryDate": "?",
 #            "type": "?",
 #            "name": "?"
 #            "cvv": "?",
 #            "address": {
 #              "line1": "?",
 #              "line2": "?",
 #              "city": "?",
 #              "state": "?",
 #              "zipcode": "?"
 #            }
 #          }
 #        }
	#     },
	#     "destinationAccount": {
	#       "bancBoxId": ? ,
	#       "subscriberReferenceId" : "?"
	#     },
	#     "items": [{
	#       "referenceId": "?",
	#       "amount": 1.00 ,
	#       "memo" : "Test Data",
	#       "scheduleDate": "?"
	#     }]
	# 	}
	# end

end