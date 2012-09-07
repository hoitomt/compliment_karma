require 'spec_helper'

describe "NewEmails" do
  
  before(:each) do
    u = FactoryGirl.create(:founder)
    visit new_shell_path
    fill_in "Email", :with => u.email
    fill_in "Password", :with => u.password
    click_button('Submit')
    reset_email
  end
  
  describe "new email confirmation" do

    before(:each) do      
    	@user = FactoryGirl.create(:user2)
      visit login_path
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => @user.password
      click_button('Log In')
      page.should have_selector("title", :content => "Profile")
    end

    it "should confirm the new email address" do
      @user.should_not be_nil
      @user.should be_confirmed
      page.driver.post user_user_emails_path( :user_id => @user.id,
                       :user_email => {:email => "testing@complimentkarma.com"})
      user_email = UserEmail.find_by_email("testing@complimentkarma.com")
      user_email.should_not be_is_confirmed
      user_email.should_not be_nil
      last_email.body.should have_content("http://test.host/email_api/new_email_confirmation?confirm_id=#{user_email.new_email_confirmation_token}")
      page.driver.get new_email_confirmation_url, :confirm_id => user_email.new_email_confirmation_token
      confirmed_email = UserEmail.find(user_email.id)
      confirmed_email.should be_is_confirmed
    end

  end

end
