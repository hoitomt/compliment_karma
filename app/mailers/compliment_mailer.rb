class ComplimentMailer < ActionMailer::Base
  default :from => 'no-reply@complimentkarma.com'

  # ACTIVE
  def send_compliment(compliment)
    @compliment = compliment
    mail to: compliment.receiver_email,
         subject: "You have received a compliment"
  end
  
  # PENDING_RECEIVER_CONFIRMATION
  def receiver_confirmation_reminder(compliment)
    @receiver = User.find_by_email(compliment.receiver_email)
    @receiver.generate_token(:new_account_confirmation_token)
    @compliment = compliment
    mail to: compliment.receiver_email,
         subject: "You have received a compliment"
  end

  # PENDING_RECEIVER_REGISTRATION
  def receiver_registration_invitation(compliment)
    @compliment = compliment
    mail to: compliment.receiver_email,
         subject: "You have received a compliment"
  end
  
  # PENDING_SENDER_CONFIRMATION
  def sender_confirmation_reminder(compliment)
    @sender = User.find_by_email(compliment.sender_email)
    @sender.generate_token(:new_account_confirmation_token)
    @compliment = compliment
    mail to: compliment.sender_email,
         subject: "Please confirm your account to send your compliment"
  end

  # PENDING_SENDER_REGISTRATION
  def sender_registration_invitation(compliment)
    @compliment = compliment
    mail to: compliment.sender_email,
         subject: "Please register for an account to send your compliment"
  end
  
end
