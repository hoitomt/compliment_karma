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
      u = follow.subject_user
      list_of_rewards += u.rewards_received.includes(:presenter, :receiver)
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

  def self.all_completed_rewards_in_visitor_domain(user, visitor)
    if visitor.domain == Domain.master_domain
      Reward.where('(receiver_id = ? OR presenter_id = ?) AND reward_status_id = ?',
                    user.id, user.id, RewardStatus.complete.id)
    else
      domains = [visitor.domain, Domain.master_domain]
      Reward.joins(:receivers, :presenters)
      Reward.joins('inner join users "receivers" on receivers.id = rewards.receiver_id', 
                   'inner join users "presenters" on presenters.id = rewards.presenter_id')
            .where('((rewards.receiver_id = ? AND presenters.domain in (?)) OR 
                     (rewards.presenter_id = ? AND receivers.domain in (?)))
                      AND rewards.reward_status_id = ?',
                   user.id, domains, user.id, domains, RewardStatus.complete.id )


      # r = user.rewards_received
      #         .joins(:users)
      #         .where('users.domain in (?) AND reward_status_id = ?', 
      #                domains, RewardStatus.complete.id)
      # rx = user.rewards_presented
      #         .joins('users on users.id = presenter_id')
      #         # .where('users.domain in (?) AND reward_status_id = ?', 
      #         #        domains, RewardStatus.complete.id)
    end
  end

  def self.all_completed_rewards(user)
    Reward.where('(receiver_id = ? OR presenter_id = ?) AND reward_status_id = ?',
                  user.id, user.id, RewardStatus.complete.id)
  end

  def self.build_employee_vo(company, activity_type_id, params)
    number_of_employees, department, start_date, stop_date = nil
    if params[:filter]
      number_of_employees = params[:filter][:number_of_employees]
      department = CompanyDepartment.find_by_id(params[:filter][:department_id])
      start_date = params[:filter][:as_of_date]
      stop_date = params[:filter][:stop_date]
      logger.info("#{number_of_employees} | #{department}")
    end
    employees = Reward.employee_universe(company, department)
    employees_result = []
    employees.each do |user|
      employees_result << get_individual_employee_vo(user, activity_type_id, 
                                                     number_of_employees, start_date, 
                                                     stop_date)
    end
    employees_result = employees_result.sort { |x, y| y[:activity_type] <=> x[:activity_type] }
    return limit(employees_result, number_of_employees.to_i)
  end

  def self.get_individual_employee_vo(user, activity_type_id,
                                      number_of_employees, start_date, 
                                      stop_date)
    e = {}
    e[:id] = user.id
    e[:full_name] = user.first_last
    e[:manager] = ''
    e[:user_type] = ''
    e[:department] = user.company_departments.first
    compliments = nil
    case activity_type_id.to_i
      when ActivityType.compliments_received.id
        compliments = Compliment.received_professional_compliments(user)
      when ActivityType.compliments_sent.id
        compliments = Compliment.sent_professional_compliments(user)
      when ActivityType.trophies_earned.id
      when ActivityType.badges_earned.id
      else
    end
    e[:activity_type] = date_range(compliments, start_date, stop_date).count
    return e
  end

  def self.limit(employees_result, number_of_employees)
    return employees_result if number_of_employees.blank?
    if employees_result.size <= number_of_employees
      return employees_result.size
    else
      return employees_result[0..(number_of_employees - 1)]
    end
  end

  def self.employee_universe(company, department)
    logger.info("Set Universe")
    if department.blank?
      return company.users
    else
      return department.users
    end
  end

  def self.date_range(c, start_date, stop_date)
    logger.info("Set Date Range")
    return [] if c.blank?
    if !start_date.blank? && !stop_date.blank?
      return c.where('created_at >= ? and created_at <= ?', start_date, stop_date)
    elsif !start_date.blank?
      return c.where('created_at >= ?', start_date)
    elsif !stop_date.blank?
      return c.where('created_at <= ?', stop_date)
    else
      return c
    end
  end

  # def self.activity_type_rank(employees, activity_type, number_of_employees)
  #   logger.info("Set Activity Type")
  #   case activity_type.id
  #     when ActivityType.compliments_received.id
  #       return User.list_of_users_ordered_by_professional_compliments_received(employees, number_of_employees)
  #     when ActivityType.compliments_sent.id
  #       return User.list_of_users_ordered_by_professional_compliments_sent(employees, number_of_employees)
  #     else
  #       return employees
  #   end
  # end

end
