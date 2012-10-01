class GroupRelationship < ActiveRecord::Base
	belongs_to :sub_group, :class_name => 'Group', :foreign_key => 'sub_group_id'
	belongs_to :super_group, :class_name => 'Group', :foreign_key => 'super_group_id'

	validates_uniqueness_of :sub_group_id, :scope => [:super_group_id]
	validate :group_is_not_related_to_a_group_of_another_user

	before_destroy :cannot_delete_relationship_to_self

	def group_is_not_related_to_a_group_of_another_user
		return if self.blank? || self.sub_group_id.blank? || self.super_group_id.blank?
		u1 = self.sub_group.group_owner
		u2 = self.super_group.group_owner
		return if u1.blank? || u2.blank?
		unless u1.id == u2.id
			errors.add(:sub_group_id, 'The group cannot be associated with another user')
		end
	end

	def cannot_delete_relationship_to_self
		if self.sub_group_id == self.super_group_id
			errors.add(:sub_group_id, 'The group must always be related to itself')
		end
		errors.blank?
	end

end
