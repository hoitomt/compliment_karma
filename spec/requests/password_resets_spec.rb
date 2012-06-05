require 'spec_helper'

describe "PasswordResets" do
  
  before(:each) do
    u = FactoryGirl.create(:founder)
    visit new_shell_path
    fill_in "Email", :with => u.email
    fill_in "Password", :with => u.password
    click_button
    reset_email
  end
  
  it "should email user when requesting password reset" do
    user = FactoryGirl.create(:user)
    visit login_path
    click_link "password"
    fill_in "Email", :with => user.email
    click_button "Reset Password"
    response.should have_selector("div", :content => "email has been sent")
    last_email.to.should include(user.email)
  end
  
  it "should not email invalid user when requesting password reset" do
    visit login_path
    click_link "password"
    fill_in "Email", :with => "madeupuser@example.com"
    click_button "Reset Password"
    last_email.should be_nil
  end
end
