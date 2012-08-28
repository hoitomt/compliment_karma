require 'spec_helper'

describe "Users" do

  before(:each) do
    u = FactoryGirl.create(:founder)
    visit new_shell_path
    fill_in "Email", :with => u.email
    fill_in "Password", :with => u.password
    click_button 'Submit'
  end
  
  describe "signup" do
    it "should be at the application root" do
      get '/'
      page.should have_selector("title", :content => "Send Compliments, Earn Rewards | ComplimentKarma")
    end
    
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Full Name", :with => ""
          fill_in "Email", :with => ""
          fill_in "Password", :with => ""
          click_button 'Sign Up Free'
          page.should have_selector('title', :content => "Sign up")
          page.has_content?('div#error_explanation')
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Full Name", :with => "Example User"
          fill_in "Email", :with => "user@complimentkarma.com"
          fill_in "Password", :with => "foobar"
          click_button 'Sign Up Free'
          page.should have_selector('title', :content => "Profile")
        end.should change(User, :count).by(1)
      end
    end
  end
end
