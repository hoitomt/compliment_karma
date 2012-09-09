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
		matching_groups = user_groups.keep_if{|g| g.group.id == group.id }
		return user_groups && !matching_groups.blank?
	end

	def check_selected(selected)
		if selected
			return "&#10003;".html_safe
		else
			return "&nbsp;".html_safe
		end
	end

	def bold_selected(selected)
		if selected
			return "font-weight: bold;".html_safe
		end
	end

end
