class Group < ActiveRecord::Base
	belongs_to :group_type
	belongs_to :group_owner, :class_name => 'User', :foreign_key => 'user_id'
	has_many :contacts
	has_many :tags
	has_many :users, :through => :contacts
	has_many :sub_group_relationships, :class_name => 'GroupRelationship', :foreign_key => 'super_group_id'
	has_many :super_group_relationships, :class_name => 'GroupRelationship', :foreign_key => 'sub_group_id'

	validates_uniqueness_of :name, :scope => [:user_id, :group_type_id]
	default_scope :order => 'sort_order'

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
		create_public(user)
		create_only_me(user)
		create_contacts(user)
		create_professional(user)
		create_social(user)
		create_relationships(user)
		# create_declined(user)
	end

	def self.create_professional(user)
		sort_o = define_sort_order('Professional')
		pro_g = create(:name => 'Professional', :user_id => user.id, 
									 :group_type => GroupType.Professional, :sort_order => sort_o,
									 :display_ind => 'Y')
	end

	def self.create_social(user)
		sort_o = define_sort_order('Social')
		soc_g = create(:name => 'Social', :user_id => user.id, 
									 :group_type => GroupType.Social, :sort_order => sort_o,
									 :display_ind => 'Y')
	end

	def self.create_relationships(user)
		pub_g = get_public_group(user)
		con_g = get_contacts_group(user)
		soc_g = get_social_group(user) 
		pro_g = get_professional_group(user)
		GroupRelationship.create(:sub_group_id => pro_g.id, :super_group_id => pro_g.id)
		GroupRelationship.create(:sub_group_id => pro_g.id, :super_group_id => pub_g.id)
		GroupRelationship.create(:sub_group_id => pro_g.id, :super_group_id => soc_g.id)
		GroupRelationship.create(:sub_group_id => pro_g.id, :super_group_id => con_g.id)
		GroupRelationship.create(:sub_group_id => soc_g.id, :super_group_id => pro_g.id)
		GroupRelationship.create(:sub_group_id => soc_g.id, :super_group_id => pub_g.id)
		GroupRelationship.create(:sub_group_id => soc_g.id, :super_group_id => soc_g.id)
		GroupRelationship.create(:sub_group_id => soc_g.id, :super_group_id => con_g.id)
	end

	def self.create_declined(user)
		sort_o = define_sort_order('Declined')
		create(:name => 'Declined', :user_id => user.id, 
			     :group_type => GroupType.Declined, :sort_order => sort_o)
	end

	def self.create_public(user)
		sort_o = define_sort_order('Public')
		create(:name => 'Public', :user_id => user.id, :sort_order => sort_o)
	end

	def self.create_only_me(user)
		sort_o = define_sort_order('Only Me')
		create(:name => 'Only Me', :user_id => user.id, :sort_order => sort_o)
	end

	def self.create_contacts(user)
		sort_o = define_sort_order('Contacts')
		create(:name => 'Contacts', :user_id => user.id, :sort_order => sort_o)
	end

	def self.get_professional_group(user)
		where('user_id = ? and name = ?', user.id, 'Professional').first
	end

	def self.get_social_group(user)
		logger.info(user.first_last)
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

	def self.define_sort_order(group_name)
		return 100 if group_name.nil?
		case group_name.downcase
		when "public"
			return 1
		when "contact of contacts"
			return 2
		when "contacts"
			return 3
		when "professional"
			return 4
		when "social"
			return 5
		when "only me"
			return 6
		else
			return 100
		end
	end

	def update_super_groups(new_super_group_ids)
		sgr = self.super_group_relationships
		existing_super_group_ids = sgr.collect{|x| x.super_group_id}
		# Establish new relationships
		new_super_group_ids.each do |sg_id|
			unless existing_super_group_ids.include?(sg_id.to_i)
				GroupRelationship.create(:sub_group_id => self.id, :super_group_id => sg_id)
			end
		end
		# Remove existing, expired, relationships
		sgr.each do |r|
			unless new_super_group_ids.include?(r.super_group_id.to_s)
				r.destroy
			end
		end
	end

	def detach_from_all_groups
		self.super_group_relationships.destroy_all
	end

	def attach_to_all_groups
		Group.public_group_list(self.group_owner).each do |super_group|
			GroupRelationship.create(:sub_group_id => self.id, :super_group_id => super_group.id)
		end
	end

	def self.public_group_list(user)
		return [] if user.blank?
		group_list = user.groups
		dg = Group.get_declined_group(user)
		om = Group.get_only_me_group(user)
		group_list.delete(dg) unless dg.blank?
		group_list.delete(om) unless om.blank?
		return group_list
	end

	def has_public_visibility?
		public_group = Group.get_public_group(self.group_owner)
		has_group_visibility?(public_group)
	end

	def has_group_visibility?(super_group)
		super_group_ids = self.super_group_relationships.collect{|sgr| sgr.super_group_id}
		return super_group_ids.include?(super_group.id)
	end

end
