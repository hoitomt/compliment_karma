class Group < ActiveRecord::Base
	belongs_to :group_type
	belongs_to :group_owner, :class_name => 'User', :foreign_key => 'user_id'
	has_many :contacts
	has_many :users, :through => :contacts

	validates_uniqueness_of :name, :scope => [:user_id, :group_type_id]

	def professional?
		return self.name == 'Professional'
	end

	def declined?
		return self.name == "Declined"
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

	def self.get_professional_group(user)
		where('user_id = ? and group_type_id =?', user.id, GroupType.Professional.id).try(:first)
	end

	def self.get_social_group(user)
		where('user_id = ? and group_type_id =?', user.id, GroupType.Social.id).try(:first)
	end

	def self.get_declined_group(user)
		where('user_id = ? and group_type_id =?', user.id, GroupType.Declined.id).try(:first)
	end
	
end
