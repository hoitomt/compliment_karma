class EmploymentType < ActiveRecord::Base
	has_many :experiences
	
	validates_presence_of :name
	validates_uniqueness_of :name
end
