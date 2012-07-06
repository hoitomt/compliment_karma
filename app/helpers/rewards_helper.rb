module RewardsHelper

	def compliments_sent(user)
		Compliment.sent_professional_compliments(@user).count
	end

	def compliments_received(user)
    Compliment.received_professional_compliments(@user).count
	end

end
