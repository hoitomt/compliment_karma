class Reward < ActiveRecord::Base  
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'
  belongs_to :presenter, :class_name => 'User', :foreign_key => 'presenter_id'

  validates_presence_of :receiver_id, :presenter_id, :value
  
  after_create :update_history

  def update_history
    UpdateHistory.Received_Reward(self)
  end

  def self.rewards_from_followed(user)
    followed = Follow.find_all_by_follower_user_id(user.id)
    list_of_rewards = []
    followed.each do |follow|
      u = User.find_by_id(follow.subject_user_id)
      list_of_rewards += u.rewards_received
    end
    return list_of_rewards
  end

  def self.earned_reward_amount(user_id)
    sum = 0
    user.rewards_received.each do |reward|
      sum += reward.value
    end
    return sum
  end

  def self.earned_reward_count(user_id)
    Reward.where('receiver_id = ?', user_id).count
  end

  def self.sent_reward_count(user_id)
    Reward.where('presenter_id = ?', user_id).count
  end

end
