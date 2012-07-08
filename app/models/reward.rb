class Reward < ActiveRecord::Base  
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'
  belongs_to :presenter, :class_name => 'User', :foreign_key => 'presenter_id'
  belongs_to :reward_status

  validates_presence_of :receiver_id, :presenter_id, :value
  validates_numericality_of :value
  
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

  def self.earned_reward_amount(user)
    sum = 0
    user.rewards_received.each do |reward|
      sum += reward.value
    end
    return sum
  end

  def self.user_type
    return ['All', 'Full Time Employee', 'Part Time Employee', 'Interns', 'Contractors']
  end

end
