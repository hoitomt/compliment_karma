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
      contacts = user.contacts.joins(:user, :group).where('groups.id = ?', filter.to_i)
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

end
