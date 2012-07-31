class InvitationMailer < ActionMailer::Base
  default :from => 'invitation@complimentkarma.com'
  
  def send_invitation(invitation)
    @invitation = invitation
    mail :to => invitation.invite_email,
         :subject => "Compliment Karma is inviting you to join"
  end

  def beta_invitation(invitation)
    @invitation = invitation
    mail :to => invitation.invite_email,
         :subject => "Compliment Karma is inviting you to join"
  end
  
end
