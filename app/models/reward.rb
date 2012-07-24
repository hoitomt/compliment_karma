class Reward < ActiveRecord::Base  
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'
  belongs_to :presenter, :class_name => 'User', :foreign_key => 'presenter_id'
  belongs_to :reward_status

  validates_presence_of :receiver_id, :presenter_id, :value
  validates_numericality_of :value
  
  after_create :update_history

  def update_history
    if self.reward_status == RewardStatus.complete
      UpdateHistory.Received_Reward(self)
    end
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

  def self.all_completed_rewards(user)
    Reward.where('(receiver_id = ? OR presenter_id = ?) AND reward_status_id = ?',
                  user.id, user.id, RewardStatus.complete.id)
  end

  def self.build_employee_vo(employees, activity_type_id)
    employees_result = []
    employees.each do |user|
      employees_result << get_individual_employee_vo(user, activity_type_id)
    end
    return employees_result
  end

  def self.get_individual_employee_vo(user, activity_type_id=nil)
    e = {}
    e[:id] = user.id
    e[:full_name] = user.first_last
    e[:manager] = ''
    e[:user_type] = ''
    e[:department] = user.company_departments.first
    case activity_type_id
      when ActivityType.compliments_received.id
        e[:activity_type] = Compliment.sent_professional_compliments(user).count
      when ActivityType.compliments_sent.id
        e[:activity_type] = Compliment.received_professional_compliments(user).count
      when ActivityType.trophies_earned.id
      when ActivityType.badges_earned.id
      else
    end
    return e
  end

end
