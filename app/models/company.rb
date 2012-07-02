class Company < ActiveRecord::Base
	# User Representation of the company
	has_one :user, :dependent => :destroy
	# Company Administrator
	has_many :company_users
	has_many :users, :through => :company_users

	def employees
		return self.users
	end

	def follow_employee(user_id)
		company_user_id = self.user.id
		unless Follow.follow_exists?(user_id, company_user_id)
			Follow.create(:subject_user_id => user_id, 
										:follower_user_id => company_user_id)
		end
		Relationship.create(:user_1_id => company_user_id,
												:user_2_id => user_id,
												:relationship_status_id => RelationshipStatus.ACCEPTED)
	end

end
