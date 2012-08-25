require 'spec_helper'

describe UserEmailsController do
	render_views

	before(:each) do 
    controller.class.skip_before_filter :shell_authenticate
    @user = FactoryGirl.create(:user)
    test_sign_in(@user)
	end

	describe "Post 'Create'" do
		before(:each) do
			@attr = {:email => "other_email@complimentkarma.com"}
		end

		it "should create a new User Email" do
			lambda do
				post :create, :user_email => @attr
			end.should change(UserEmail, :count).by(1)
		end
	end

	describe "Post 'Set Primary" do
		before(:each) do
			@user_email_2 = UserEmail.create(:user_id => @user.id, :email => "new_email@complimentkarma.com")
		end

		it "should create the second email with primary of N" do
			@user_email_2.is_primary?.should be_false
		end

		it "should update the second email to primary" do
			# Verify that the email address is primary
			user_email_1 = UserEmail.where(:user_id => @user.id, :email => @user.email).first
			user_email_1.is_primary?.should be_true
			# Set the second address to primary
			post :set_primary_email, :user_email_id => @user_email_2.id
			user_email_2 = UserEmail.find(@user_email_2.id)
			user_email_1 = UserEmail.find(user_email_1.id)
			user_email_2.is_primary?.should be_true
			user_email_1.is_primary?.should be_false
		end

	end


end
