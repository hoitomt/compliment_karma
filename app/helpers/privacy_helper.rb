module PrivacyHelper

	# is the group a super group of the subject group 
	# (i.e. does it live in the subject_groups super_group_relationships)
	def super_group?(group, subject_group)
		super_group_relationship_ids = subject_group.super_group_relationships.collect{|sgr| sgr.super_group_id }
		return true if super_group_relationship_ids.include?(group.id)
		return false
	end


end