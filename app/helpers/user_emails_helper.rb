module UserEmailsHelper

	def email_status_class(user_email)
		if user_email.is_primary?
			return "primary"
		elsif !user_email.is_confirmed?
			return "unconfirmed"
		else
			return "non-primary"
		end
	end

	def email_primary_link(user_email)
		if !user_email.is_confirmed?
			return link_to "Send Confirmation Email", 
										 resend_new_account_confirmation_path(:id => current_user.id),
										 :remote => true
		elsif user_email.is_primary?
			return "<span class='color: green;'>Primary email</span>".html_safe
		else
			return link_to 'Make Primary', set_primary_email_path(:id => user_email.id), :remote => true
		end
	end

end
