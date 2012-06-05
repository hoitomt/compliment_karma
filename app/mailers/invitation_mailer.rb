class InvitationMailer < ActionMailer::Base
  default :from => 'no-reply@complimentkarma.com'
  
  def send_invitation(invitation)
    @invitation = invitation
    mail :to => invitation.invite_email,
         :subject => "Compliment Karma is inviting you to join"
  end
  
end
