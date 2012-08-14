class ComplimentMailer < ActionMailer::Base
  default :from => 'no-reply@complimentkarma.com'

  # ACTIVE
  def send_compliment(compliment)
    @compliment = compliment
    @skill= Skill.find_by_id(@compliment.skill_id)
    @sender = @compliment.sender
    @receiver = @compliment.receiver
    @first_compliment = Compliment.first_compliment?(@sender, @receiver)
    @relationship = Relationship.get_relationship(@sender, @receiver)
    @confirmed_relationship = @relationship.accepted? if @relationship
    @timestamp = DateUtil.get_time_gap(@compliment.created_at)
    mail to: compliment.receiver_email,
         subject: "You have received a compliment",
         from: "new_compliment@complimentkarma.com"
  end
  
  # PENDING_RECEIVER_CONFIRMATION
  def receiver_confirmation_reminder(compliment)
    @compliment = compliment
    @sender = @compliment.sender
    @receiver = @compliment.receiver
    @receiver.generate_token(:new_account_confirmation_token)
    @skill= Skill.find_by_id(@compliment.skill_id)
    @timestamp = DateUtil.get_time_gap(@compliment.created_at)
    mail to: compliment.receiver_email,
         subject: "You have received a compliment",
         from: "new_compliment@complimentkarma.com"
  end

  # PENDING_RECEIVER_REGISTRATION
  def receiver_registration_invitation(compliment)
    @compliment = compliment
    @sender = @compliment.sender
    @skill= Skill.find_by_id(@compliment.skill_id)
    @timestamp = DateUtil.get_time_gap(@compliment.created_at)
    mail to: @compliment.receiver_email,
         subject: "You have received a compliment",
         from: "new_compliment@complimentkarma.com"
  end

  # Unregistered user is attempting to use our api
  def notify_ck_unrecognized_sender(params)
    @params = params
    mail to: 'admin@complimentkarma.com',
         subject: 'Attempted unrecognized access of the New Compliment Email API'
  end

  def notify_sender_unrecognized_sender(params, sender_email)
    @params = params
    mail to: sender_email,
         subject: 'Unrecognized access of ComplimentKarma'
  end
  
  def notify_sender_unconfirmed_sender(params, user)
    @params = params
    @user = user
    mail to: user.email,
         subject: 'Please confirm your account before using ComplimentKarma'
  end

  def notify_sender_unknown_skill(user, compliment)
    @user = user
    @compliment = compliment
    mail to: user.email,
         subject: 'Your recent compliment did not specify a skill'
  end
end
