class UpdateHistoryType < ActiveRecord::Base
	has_many :update_histories

	validates_uniqueness_of :name

	def self.Received_Compliment
		UpdateHistoryType.find_by_name('Received Compliment')
	end
	
	def self.Accepted_Compliment_Receiver
		UpdateHistoryType.find_by_name('Accepted Compliment Receiver')
	end

	def self.Rejected_Compliment_Receiver
		UpdateHistoryType.find_by_name('Rejected Compliment Receiver')
	end
	
	def self.Comment_on_Received_Compliment
		UpdateHistoryType.find_by_name('Comment on Received Compliment')
	end

	def self.Comment_on_Sent_Compliment
		UpdateHistoryType.find_by_name('Comment on Sent Compliment')
	end

	def self.Like_Received_Compliment
		UpdateHistoryType.find_by_name('Like Received Compliment')
	end

	def self.Like_Sent_Compliment
		UpdateHistoryType.find_by_name('Like Sent Compliment')
	end

	def self.Share_Received_Compliment_On_Facebook
		UpdateHistoryType.find_by_name('Share Received Compliment On Facebook')
	end

	def self.Share_Sent_Compliment_On_Facebook
		UpdateHistoryType.find_by_name('Share Sent Compliment On Facebook')
	end

	def self.Share_Received_Compliment_On_Twitter
		UpdateHistoryType.find_by_name('Share Received Compliment On Twitter')
	end

	def self.Share_Sent_Compliment_On_Twitter
		UpdateHistoryType.find_by_name('Share Sent Compliment On Twitter')
	end
	
	def self.Following_You
		UpdateHistoryType.find_by_name('Following You')
	end

	def self.Received_Reward
		UpdateHistoryType.find_by_name('Received Reward')
	end

	def self.Comment_on_Reward
		UpdateHistoryType.find_by_name('Comment on Reward')
	end

	def self.Like_Reward
		UpdateHistoryType.find_by_name('Like Reward')
	end

	def self.Share_Reward_on_Facebook
		UpdateHistoryType.find_by_name('Share Reward on Facebook')
	end

	def self.Share_Reward_on_Twitter
		UpdateHistoryType.find_by_name('Share Reward on Twitter')
	end

	def self.Earned_an_Accomplishment
		UpdateHistoryType.find_by_name('Earned an Accomplishment')
	end

	def self.Comment_on_Accomplishment
		UpdateHistoryType.find_by_name('Comment on Accomplishment')
	end

	def self.Like_Accomplishment
		UpdateHistoryType.find_by_name('Like Accomplishment')
	end

	def self.Share_Accomplishment_on_Facebook
		UpdateHistoryType.find_by_name('Share Accomplishment on Facebook')
	end

	def self.Share_Accomplishment_on_Twitter
		UpdateHistoryType.find_by_name('Share Accomplishment on Twitter')
	end

end
