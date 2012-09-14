require 'spec_helper'

describe "Privacy" do

  let(:user2) {FactoryGirl.create(:user2)}
  let(:user3) {FactoryGirl.create(:user3)}
  let(:unconfirmed_user) {FactoryGirl.create(:unconfirmed_user)}
  let(:unconfirmed_user2) {FactoryGirl.create(:unconfirmed_user2)}
  let(:sears_user) {FactoryGirl.create(:sears_user)}
  let(:groupon_user) {FactoryGirl.create(:groupon_user)}
  
  before(:each) do
  	Compliment.delete_all
    visit login_path
    fill_in "Email", :with => user2.email
    fill_in "Password", :with => user2.password
    click_button('Log In')
    page.should have_selector("title", :content => "Profile")
  end

  it "should show the correct number of items in karma activity" do

  end


end