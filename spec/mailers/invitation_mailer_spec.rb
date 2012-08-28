require "spec_helper"

describe InvitationMailer do
  let(:user) { FactoryGirl.create(:user, :password_reset_token => "anything")}
  let(:invitation) { FactoryGirl.create(:invitation) }
  let(:mail) { InvitationMailer.send_invitation(invitation)}
  
  it "should send invitation in subject and body" do
    mail.subject.should eq("Compliment Karma is inviting you to join")
    mail.to.should eq([invitation.invite_email])
    mail.from.should eq(['invitation@complimentkarma.com'])
  end
  
end
