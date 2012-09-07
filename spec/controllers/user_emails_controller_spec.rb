require 'spec_helper'

describe UserEmailsController do
	render_views

	let(:user3){FactoryGirl.create(:user3)}

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
				post :create, :user_email => @attr, :user_id => @user.id 
			end.should change(UserEmail, :count).by(1)
		end

		it "should send a confirmation email to the new address" do 
			reset_email
			post :create, :user_email => @attr, :user_id => @user.id 
			user_email = UserEmail.last
			last_email.to[0].should == user_email.email
			last_email.body.should have_content(new_email_confirmation_url(:confirm_id => user_email.new_email_confirmation_token))
		end

		it "should associate previous compliments" do
			c = Compliment.create(:sender_email => user3.email, :receiver_email => @attr[:email],
												 :skill_id => Skill.first.id, :comment => "I like Pie",
												 :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL.id)
			c.should be_valid
			x = user3.compliments_sent
			x.length.should == 1
			reset_email
			post :create, :user_email => @attr, :user_id => @user.id 
			# after create, the compliments should be associated (receiver_user_id is updated)
			y = @user.compliments_received
			y.length.should == 1
			y[0].receiver_user_id.should == @user.id
			y[0].compliment_status.should == ComplimentStatus.ACTIVE
		end
	end

	describe "Post 'Set Primary'" do
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
			post :set_primary_email, :id => @user_email_2.id, :user_id => @user.id 
			user_email_2 = UserEmail.find(@user_email_2.id)
			user_email_1 = UserEmail.find(user_email_1.id)
			user_email_2.is_primary?.should be_true
			user_email_1.is_primary?.should be_false
		end

	end

	describe 'Destroy' do
		before(:each) do
			@attr = {:email => "other_email@complimentkarma.com"}
		end

		it "should create a new User Email" do
			lambda do
				post :create, :user_email => @attr, :user_id => @user.id 
			end.should change(UserEmail, :count).by(1)
		end

		it "should not allow you to delete the primary email" do
			email = @user.email
			user_email = @user.primary_email
			lambda do
				delete :destroy, :id => user_email.id, :user_id => @user.id 
			end.should_not change(UserEmail, :count)
		end

		it "should be successful" do
			post :create, :user_email => @attr, :user_id => @user.id 
			e = UserEmail.last
			e.email.should == @attr[:email]
			lambda do
				delete :destroy, :id => e.id, :user_id => @user.id 
			end.should change(UserEmail, :count).by(-1)
		end

		it "should disassociate all compliments" do
			post :create, :user_email => @attr, :user_id => @user.id 
			e = UserEmail.last
			e.email.should == @attr[:email]
			c = Compliment.create(:sender_email => user3.email, :receiver_email => e.email,
												 :skill_id => Skill.first.id, :comment => "I like Pie",
												 :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL.id)
			c.should be_valid
			x = user3.compliments_sent
			x.length.should == 1
			reset_email
			delete :destroy, :id => e.id, :user_id => @user.id 
			# after delete, the compliments should be disassociated (receiver_user_id is updated to nil)
			y = User.find(user3.id).compliments_sent
			y.length.should == 1
			y[0].receiver_user_id.should be_nil
			# after delete the compliment should no longer be associated with the user
			y = @user.compliments_received
			y.length.should == 0
		end

	end


end
