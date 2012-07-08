class RewardStatus < ActiveRecord::Base
	has_many :rewards

  validates_uniqueness_of :name

	def self.pending
		return RewardStatus.find_by_name('Pending')
	end

	def self.complete
		return RewardStatus.find_by_name('Complete')
	end

end
