class GroupType < ActiveRecord::Base
	has_many :groups

  validates_uniqueness_of :name
	# Professional, Social, Declined
	
	def self.Professional
		find_by_name('Professional')
	end

	def self.Social
		find_by_name('Social')
	end

	def self.Declined
		find_by_name('Declined')
	end
	
end
