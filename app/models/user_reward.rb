class UserReward < ActiveRecord::Base
  belongs_to :reward
  belongs_to :user

  after_create :update_history

  def update_history
    UpdateHistory.Received_Reward(self)
  end

  def self.rewards_from_followed(user)
    followed = Follow.find_all_by_follower_user_id(user.id)
    list_of_rewards = []
    followed.each do |follow|
      u = User.find_by_id(follow.subject_user_id)
      list_of_rewards += u.user_rewards
    end
    return list_of_rewards
  end

  def self.earned_reward_amount(user_id)
    user_rewards = UserReward.where('user_id = ?', user_id)
    sum = 0
    user_rewards.each do |user_reward|
      sum += user_reward.reward.value if user_reward.reward && user_reward.reward.value
    end
    return sum
  end

  def self.earned_reward_count(user_id)
    UserReward.where('user_id = ?', user_id).count
  end

  def self.sent_reward_count(user_id)
    UserReward.where('presenter_id = ?', user_id).count
  end
end
