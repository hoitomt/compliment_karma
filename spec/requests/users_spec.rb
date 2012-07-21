require 'spec_helper'

describe "Users" do

  before(:each) do
    u = FactoryGirl.create(:founder)
    visit new_shell_path
    fill_in "Email", :with => u.email
    fill_in "Password", :with => u.password
    click_button
  end
  
  describe "signup" do
    it "should be at the application root" do
      get '/'
      response.should have_selector("title", :content => "Compliment Karma Application")
    end
    
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Full Name", :with => ""
          fill_in "Email", :with => ""
          fill_in "Password", :with => ""
          click_button
          response.should render_template('users/new')
          # response.should have_selector('div#error_explanation')
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Full Name", :with => "Example User"
          fill_in "Email", :with => "user@example.com"
          fill_in "Password", :with => "foobar"
          click_button
          response.should render_template('pages/invite_coworkers')
        end.should change(User, :count).by(1)
      end
    end
  end
end
