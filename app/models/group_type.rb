class GroupType < ActiveRecord::Base
	has_many :groups

  validates_uniqueness_of :name
	# Professional, Social, Declined
	
end
