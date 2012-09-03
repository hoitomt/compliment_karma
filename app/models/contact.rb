class Contact < ActiveRecord::Base
	belongs_to :user
	belongs_to :group

	validates_presence_of :group_id, :user_id
	validate :user_already_in_group
	validate :user_is_not_group_owner

	def user_already_in_group
		group = Group.find(group_id)
		members = group.contacts
		user_in_table = members.keep_if{|c| c.user_id == self.user_id}
		unless user_in_table.blank?
			errors.add(:user_id, "User already exists in this group")
		end
	end

	def user_is_not_group_owner
		group = Group.find(group_id)
		if self.user_id == group.group_owner.id
			errors.add(:user_id, "User cannot add themselves to their own group")
		end
	end

	def self.add_to_group(user, group_id)
		
	end

end
