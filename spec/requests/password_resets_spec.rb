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

  it "should reset the password" do
    user = FactoryGirl.create(:user)
    visit login_path
    click_link "password"
    fill_in "Email", :with => user.email
    click_button "Reset Password"
    response.should have_selector("div", :content => "email has been sent")
    u = User.find(user.id)
    u.password_reset_token.should_not be_nil
    last_email.to.should include(u.email)
    last_email.body.should have_selector('a',
                           :href => "http://test.host/password_resets/#{u.password_reset_token}/edit")

    visit edit_password_reset_url(u.password_reset_token)
    response.should be_success
    fill_in "New Password", :with => "imatest"
    click_button "Submit"
    response.should be_success
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "imatest"
    click_button "Log in"
    response.should render_template('users/show')
  end
end
