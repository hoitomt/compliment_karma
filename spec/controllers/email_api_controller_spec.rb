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

  before(:each) do
    @params = {
      'from' => user2.email,
      'To' => user3.email,
      'body-plain' => "Great Job \r\n^ruby on rails^\r\nThanks, Mike",
      'stripped-text' => "Great Job ^ruby on rails^ Thanks, Mike"
    }
  end
  
  describe "POST compliment new" do
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
  end

end