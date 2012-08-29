require 'spec_helper'

describe EmailApiController do
	render_views

  let(:user) {FactoryGirl.create(:user)}
  let(:user2) {FactoryGirl.create(:user2)}
  let(:user3) {FactoryGirl.create(:user3)}
  let(:dummy) {User.find_by_email('dummy@example.org')}

  before(:each) do
    controller.class.skip_before_filter :shell_authenticate
  end
  
  describe "POST compliment new" do

    before(:each) do
      @params = {
        'from' => user2.email,
        'To' => user3.email,
        'body-plain' => "Great Job \r\n^ruby on rails^\r\nThanks, Mike",
        'stripped-text' => "Great Job ^ruby on rails^ Thanks, Mike"
      }
    end

  	it "should create a new compliment" do
  		lambda do
				post :compliment_new, @params
	  	end.should change(Compliment, :count).by(1)
  	end

  	it "should not create a new compliment from unrecognized sender" do
  		@params['from'] = "seargant@shriver.com"
  		lambda do
				post :compliment_new, @params
	  	end.should_not change(Compliment, :count).by(1)
  	end

  	it "should not create a new compliment from email forwarder like Mailgun" do
  		@params['To'] = "new@ck.mailgun.org"
  		lambda do
				post :compliment_new, @params
	  	end.should_not change(Compliment, :count).by(1)
  	end

    it "should find the senders other email address" do
      ue = UserEmail.create(:user_id => user2.id, :email => "user2@groupon.com")
      user = User.find(user2.id)
      user.email_addresses.length.should == 2
      @params['from'] = ue.email
      lambda do
        post :compliment_new, @params
      end.should change(Compliment, :count).by(1)
    end

    it "should find the receivers other email address" do
      ue = UserEmail.create(:user_id => user3.id, :email => "user3@groupon.com")
      user = User.find(user3.id)
      user.email_addresses.length.should == 2
      @params['To'] = ue.email
      lambda do
        post :compliment_new, @params
      end.should change(Compliment, :count).by(1)
      c = user2.compliments_sent.first
      c.receiver_email.should == ue.email
      c.receiver_user_id.should == ue.user_id
    end

  end

end