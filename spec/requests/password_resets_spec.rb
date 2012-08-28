require 'spec_helper'

describe "PasswordResets" do
  
  before(:each) do
    u = FactoryGirl.create(:founder)
    visit new_shell_path
    fill_in "Email", :with => u.email
    fill_in "Password", :with => u.password
    click_button('Submit')
    reset_email
  end
  
  it "should email user when requesting password reset" do
    user = FactoryGirl.create(:user)
    visit login_path
    click_link "Forgot Password?"
    fill_in "Email", :with => user.email
    click_button "Reset Password"
    page.should have_selector("div", :content => "email has been sent")
    last_email.to.should include(user.email)
  end
  
  it "should not email invalid user when requesting password reset" do
    visit login_path
    click_link "Forgot Password?"
    fill_in "Email", :with => "madeupuser@example.com"
    click_button "Reset Password"
    last_email.should be_nil
  end

  it "should reset the password" do
    user = FactoryGirl.create(:user)
    visit login_path
    click_link "Forgot Password?"
    fill_in "Email", :with => user.email
    click_button "Reset Password"
    page.should have_selector("div", :content => "email has been sent")
    u = User.find(user.id)
    u.password_reset_token.should_not be_nil
    last_email.to.should include(u.email)
    last_email.body.should have_selector('a',
                           :href => "http://test.host/password_resets/#{u.password_reset_token}/edit")

    visit edit_password_reset_url(u.password_reset_token)
    page.should have_selector('title', :content => "Password Reset")
    fill_in "New Password", :with => "imatest"
    click_button "Submit"
    page.should have_selector("title", :content => "Log in")
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "imatest"
    click_button "Log In"
    page.should have_selector("title", :content => "Profile")
  end
end
