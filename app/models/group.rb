class Group < ActiveRecord::Base
	belongs_to :group_type
	belongs_to :group_owner, :class_name => 'User', :foreign_key => 'user_id'
	has_many :contacts
	has_many :tags
	has_many :users, :through => :contacts
	has_many :sub_group_relationships, :class_name => 'GroupRelationship', :foreign_key => 'super_group_id'
	has_many :super_group_relationships, :class_name => 'GroupRelationship', :foreign_key => 'sub_group_id'

	validates_uniqueness_of :name, :scope => [:user_id, :group_type_id]

	def display?
		return self.display_ind.downcase == "y"
	end

	def professional?
		return self.name.downcase == 'professional'
	end

	def social?
		return self.name.downcase == 'social'
	end

	def declined?
		return self.name.downcase == "declined"
	end

	def public?
		return self.name.downcase == "public"
	end

	def only_me?
		return self.name.downcase == "only me"
	end

	def contacts?
		return self.name.downcase == "contacts"
	end

	def self.initialize_groups(user)
		create_professional(user)
		create_social(user)
		create_declined(user)
		create_public(user)
		create_only_me(user)
		create_contacts(user)
	end

	def self.create_professional(user)
		create(:name => 'Professional', :user_id => user.id, :group_type => GroupType.Professional)
	end

	def self.create_social(user)
		create(:name => 'Social', :user_id => user.id, :group_type => GroupType.Social)
	end

	def self.create_declined(user)
		create(:name => 'Declined', :user_id => user.id, :group_type => GroupType.Declined)
	end

	def self.create_public(user)
		create(:name => 'Public', :user_id => user.id)
	end

	def self.create_only_me(user)
		create(:name => 'Only Me', :user_id => user.id)
	end

	def self.create_contacts(user)
		create(:name => 'Contacts', :user_id => user.id)
	end

	def self.get_professional_group(user)
		where('user_id = ? and name = ?', user.id, 'Professional').first
	end

	def self.get_social_group(user)
		where('user_id = ? and name = ?', user.id, 'Social').first
	end

	def self.get_declined_group(user)
		where('user_id = ? and name = ?', user.id, 'Declined').first
	end

	def self.get_public_group(user)
		where('user_id = ? and name = ?', user.id, 'Public').first
	end

	def self.get_only_me_group(user)
		where('user_id = ? and name = ?', user.id, 'Only Me').first
	end

	def self.get_contacts_group(user)
		where('user_id = ? and name = ?', user.id, 'Contacts').first
	end
	
	def self.get_sender_group_by_compliment_type(compliment_type, user)
		logger.info("Compliment Type: #{compliment_type.name} - Professional: #{compliment_type.professional_sender?}")
		if compliment_type.professional_sender?
			logger.info("Professional Group: #{get_professional_group(user).id}")
			return get_professional_group(user)
		elsif compliment_type.social_sender?
			logger.info("Professional Group: #{get_professional_group(user).id}")
			return get_social_group(user)
		else
			logger.info("NIL - Professional Group: #{get_professional_group(user).id}")
			return nil
		end
	end

	def self.get_receiver_group_by_compliment_type(compliment_type, user)
		if compliment_type.professional_receiver?
			return get_professional_group(user)
		elsif compliment_type.social_receiver?
			return get_social_group(user)
		else
			return nil
		end
	end

end
