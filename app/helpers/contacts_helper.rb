module ContactsHelper

	def border_color(contact)
		if contact.blank?
			return ""
		elsif contact.try(:group).try(:professional?)
			return "professional"
		elsif contact.try(:group).try(:social?)
			return "social"
		end
	end

	def group_selected(group, c_user_memberships)
		user_groups = Array.new(c_user_memberships)
		logger.info("User Groups: #{c_user_memberships.join(',')}")
		matching_groups = user_groups.keep_if{|g| g.group.id == group.id }
		if user_groups && !matching_groups.blank?
			return "&#10003;".html_safe
		else
			return "&nbsp;".html_safe
		end

		# if contact.group.id.to_i == group.id.to_i
		# 	return "&#10003;".html_safe
		# else
		# 	return "&nbsp;".html_safe
		# end
	end

end
