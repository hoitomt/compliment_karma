class Group < ActiveRecord::Base
	belongs_to :group_type
	belongs_to :group_owner, :class_name => 'User', :foreign_key => 'user_id'
	has_many :contacts
	has_many :users, :through => :contacts
end
