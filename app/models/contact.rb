class Contact < ActiveRecord::Base
	belongs_to :user
	belongs_to :group

	validates_presence_of :group_id, :user_id
	validate :user_already_in_group
	validate :user_is_not_group_owner

	def user_already_in_group
		group = self.group
		return if group.blank?
		members = group.try(:contacts)
		user_in_table = members.keep_if{|c| c.user_id == self.user_id} if members
		unless user_in_table.blank?
			errors.add(:user_id, "The selected user is already one of your contacts")
		end
	end

	def user_is_not_group_owner
		group = Group.find_by_id(group_id)
		return if group.blank?
		if self.user_id == group.group_owner.id
			errors.add(:user_id, "User cannot add themselves to their own group")
		end
	end

	def self.add_to_group(user, group_id)
		
	end

	def self.group_counts(user)
    h = Hash.new(0)
    user.groups.each do |group|
      h[group.id] = user.contacts.joins(:user, :group).where('groups.id = ?', group.id).count
    end
    return h
	end

	def self.filtered_list(user, filter)
		if filter.blank?
      contacts = user.contacts.includes(:user, :group, {:user => :memberships}).uniq{|x| x.user_id}
    else
      contacts = user.contacts.unscoped.joins(:user, :group).where('groups.id = ?', filter.to_i)
    end
    return contacts.sort!{|x, y| 
    	x_name_string = "#{x.try(:user).try(:last_name)} #{x.try(:user).try(:first_name)}"
    	y_name_string = "#{y.try(:user).try(:last_name)} #{y.try(:user).try(:first_name)}"
    	# x <=> y
    	x_name_string <=> y_name_string
    }
	end

	def self.create_declined_contact(contact_user, group_owner)
		declined_group = Group.get_declined_group(group_owner)
		Contact.create(:group_id => declined_group.id, :user_id => contact_user.id)
	end

	def self.remove_declined_contact(contact_user, group_owner)
		declined_group = Group.get_declined_group(group_owner)
		declined_contacts = contact_user.memberships.where('group_id = ?', declined_group.id)
		unless declined_contacts.blank?
			declined_contacts.first.delete
		end
	end

	def self.get_contact_groups(user, contact_user)
		return [] if user.blank? || contact_user.blank?
		sql = "SELECT distinct g.* from groups g
					 JOIN users u on g.user_id = u.id
					 JOIN contacts c on g.id = c.group_id
					 WHERE u.id = ?
					 AND c.user_id = ?"
		Group.find_by_sql([sql, user.id, contact_user.id])
	end

	def self.update_groups(user, contact_user, new_group_ids)
		return if contact_user.blank? || user.blank? || new_group_ids.blank?
		logger.info("New Groups: #{new_group_ids}")
		existing_groups = get_contact_groups(user, contact_user)
		existing_group_ids = existing_groups.collect{|g| g.id.to_s }
		logger.info("Existing Groups: #{existing_group_ids}")

		# Add user to group
		new_group_ids.each do |g_id|
			unless existing_group_ids.include?(g_id)
				Contact.create(:group_id => g_id, :user_id => contact_user.id)
			end
		end

		# Remove contacts that are no longer validate
		existing_group_ids.each do |eg_id|
			unless new_group_ids.include?(eg_id)
				c_delete_me = Contact.where(:group_id => eg_id, :user_id => contact_user.id)
				c_delete_me.destroy_all
			end
		end

	end

	def self.create_from_compliment(compliment)
    unless compliment.receiver_user_id.blank?
      group = Group.get_sender_group_by_compliment_type(compliment.compliment_type, compliment.sender)
      logger.info(group.inspect)
      if group
	      create(:group_id => group.id, :user_id => compliment.receiver_user_id)
	    end
    end
	end

end
