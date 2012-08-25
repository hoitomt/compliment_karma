require 'spec_helper'

describe UserEmail do
	let(:user2){FactoryGirl.create(:user2)}

	before(:each) do
		@attr = {
			:user_id => user2.id,
			:email => "my_email@complimentkarma.com"
		}
	end

	it "should create a user email" do
		UserEmail.create!(@attr)
	end

	it "should require a user id" do
		u = UserEmail.new(@attr.merge(:user_id => ""))
		u.should_not be_valid
	end

	it "should set the domain" do
		u = UserEmail.create!(@attr)
		u.domain.should == "complimentkarma.com"
	end

	it "should set confirm" do
		u = UserEmail.create!(@attr)
		u.confirmed.should == "N"
	end

	it "should set primary" do
		u = UserEmail.create!(@attr)
		u.primary.should == "N" # When the factory creates the user, it creates the primary
	end

	describe "primary failure" do
		it "should only default one primary email address" do
			u = UserEmail.create!(@attr)
			ux = UserEmail.create!(@attr.merge(:email => "other_email@complimentkarma.com"))
			u.primary.should == "N"
			ux.primary.should == "N"
		end

		it "should only set one primary email address" do
			u = UserEmail.create!(@attr)
			ux = UserEmail.create!(@attr.merge(:email => "other_email@complimentkarma.com",
																				 :primary => "Y"))
			u.primary.should == "N"
			ux.primary.should == "N"
		end
	end

	describe "new user creation" do
		before(:each) do
			@user_attr = { :name => "Santa Claus",
										 :email => "north_pole@complimentkarma.com",
										 :password => "rudolph" }
		end

		it "should create a user email when creating a user" do
			lambda do
				User.create!(@user_attr)
			end.should change(User, :count).by(1)
			email = User.last.email_addresses.first
			email.should_not be_nil
			email.is_primary?.should == true
		end
	end

end
