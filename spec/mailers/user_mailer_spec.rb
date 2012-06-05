require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    let(:user) { FactoryGirl.create(:user, :password_reset_token => "anything")}
    let(:mail) { UserMailer.password_reset(user)}
    
    it "should send user password reset url" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([user.email])
      mail.from.should eq(['no-reply@complimentkarma.com'])
    end
    
    it "should render the body" do
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end

end
