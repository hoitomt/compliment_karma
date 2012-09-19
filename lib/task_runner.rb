class TaskRunner

	def self.run_task
		create_groups_and_migrate
	end

	# Create the public, only me, and contacts groups and associations
	def self.create_more_groups_and_relationships
		@users = User.all
		@users.each do |user|
			pro_g = Group.get_professional_group(user)
			soc_g = Group.get_social_group(user)
			pub_g = Group.create(:name => 'Public', :user_id => user.id)
			only_me_g = Group.create(:name => 'Only Me', :user_id => user.id)
			contacts_g = Group.create(:name => 'Contacts', :user_id => user.id)
			GroupRelationship.create(:sub_group_id => pro_g.id, :super_group_id => pro_g.id)
			GroupRelationship.create(:sub_group_id => pro_g.id, :super_group_id => pub_g.id)
			GroupRelationship.create(:sub_group_id => soc_g.id, :super_group_id => soc_g.id)
			GroupRelationship.create(:sub_group_id => soc_g.id, :super_group_id => pub_g.id)
			GroupRelationship.create(:sub_group_id => pub_g.id, :super_group_id => pub_g.id)
			GroupRelationship.create(:sub_group_id => only_me_g.id, :super_group_id => only_me_g.id)
			GroupRelationship.create(:sub_group_id => contacts_g.id, :super_group_id => contacts_g.id)
		end
	end

	# Create the user groups and assign relationships to groups
	def self.create_groups_and_migrate
		@users = User.all
		@users.each do |user|
			user.create_groups
			pro_group = Group.get_professional_group(user)
			relationships = Relationship.get_relationships(user)
			relationships.each do |r|
				other_user = r.get_other_user(user)
				if r.relationship_status != RelationshipStatus.NOT_ACCEPTED && !other_user.blank?
					Contact.create(:group_id => pro_group.id, :user_id => other_user.id)
				end
			end
		end
	end

	# Initialize the Redis instance with user data
	def self.add_users_to_redis
		users = User.all
		users.each do |u|
			u.add_to_redis
		end
	end

	# Copy the email addresses from User to UserEmail and set to Primary
	def self.user_email
		users = User.all
		account_status_confirmed = AccountStatus.CONFIRMED.id
		users.each do |u|
			confirmed = u.account_status_id == account_status_confirmed ? 'Y' : 'N'
			puts confirmed
			UserEmail.create(:user_id => u.id,
											 :email => u.email,
											 :domain => u.domain,
											 :confirmed => confirmed, 
											 :primary_email => 'Y')
		end
	end

	# Set the compliment type names
	def self.compliment_type
		c = ComplimentType.all
		c[0].update_attributes(:name => "Professional to Professional", 
													 :list_name => "from my PROFESSIONAL to receivers PROFESSIONAL profile")
		c[1].update_attributes(:name => "Professional to Social", 
													 :list_name => "from my PROFESSIONAL to receivers SOCIAL profile")
		c[2].update_attributes(:name => "Social to Professional", 
													 :list_name => "from my SOCIAL to receivers PROFESSIONAL profile")
		c[3].update_attributes(:name => "Social to Social", 
													 :list_name => "from my SOCIAL to receivers SOCIAL profile")
	end
end