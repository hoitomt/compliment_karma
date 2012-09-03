require 'spec_helper'

describe ContactsController do
	render_views

	let(:user2){ FactoryGirl.create(:user2) }
  let(:user3){ FactoryGirl.create(:user3) }

  before(:each) do
    @new_title = "Sign up"
    controller.class.skip_before_filter :shell_authenticate
    @user2 = FactoryGirl.create(:user2)
    @user3 = FactoryGirl.create(:user3)
    @user2.groups.count.should == 3
    @user3.groups.count.should == 3
    test_sign_in(@user2)
  end

  describe "POST 'create'" do
  	before(:each) do
  		@attr = {
  			:group_id => @user2.groups.first,
  			:user_id => @user3.id
  		}
  	end

  	it "should create new contact" do
  		lambda do
	  		post :create, {:contact => @attr, :user_id => @user2.id}
	  	end.should change(Contact, :count).by(1)
  	end

  	it "should add user as new contact" do
  		post :create, {:contact => @attr, :user_id => @user2.id}
  		@user3.memberships.count.should == 1
  		@user2.contacts.count.should == 1
  		@user2.contacts.first.group.group_type.should == @user2.groups.first.group_type
  	end

  	it "should not create a duplicate contact" do
  		post :create, {:contact => @attr, :user_id => @user2.id}
  		@user3.memberships.count.should == 1
  		post :create, {:contact => @attr, :user_id => @user2.id}
  		@user3.memberships.count.should == 1
  		@user2.contacts.count.should_not == 2
  	end

  end

end
