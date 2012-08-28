require 'spec_helper'

describe Invitation do
  let(:invitation) { FactoryGirl.create(:invitation) }
  
  before(:each) do
    @attr = {:invite_email => "a_test@example.org", :from_email => "this_guy@example.org"}
  end
  
  it "should create a new instance given valid attributes" do
    invitation = Invitation.create!(@attr)
  end
  
  it "should require an invite_email" do
    no_invite_email = Invitation.new(@attr.merge(:invite_email => ""))
    no_invite_email.should_not be_valid
  end
  
  it "should require a valid invite_email" do
    no_invite_email = Invitation.new(@attr.merge(:invite_email => "assdd"))
    no_invite_email.should_not be_valid
  end
  
  it "should send an email" do
    invitation.send_invitation
    last_email.to.should include invitation.invite_email
  end
  
end
