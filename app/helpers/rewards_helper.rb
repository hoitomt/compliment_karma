module RewardsHelper

	def compliments_sent(user)
		Compliment.sent_professional_compliments(@user).count
	end

	def compliments_received(user)
    Compliment.received_professional_compliments(@user).count
	end

	def department(user)
		if !user.blank? && !user.company_departments.blank?
			dept = user.company_departments.first.name
		else
			return "None"
		end
	end

	def employee_vo(employee)
		Reward.get_individual_employee_vo(employee)
	end

end
