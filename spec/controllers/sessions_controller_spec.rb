require 'spec_helper'

describe SessionsController do
  render_views
  
  before(:each) do
    controller.class.skip_before_filter :shell_authenticate
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.body.should have_selector("title", :content => "Log in")
    end
  end
  
  describe "POST create" do
    
    describe "invalid signin" do
      
      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end
      
      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end
      
      it "should have the right title" do
        post :create, :session => @attr
        response.body.should have_selector("title", :content => "Log in")
      end
      
      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end      
    end
    
    describe "signin with valid email and password" do
      before(:each) do
        @user = FactoryGirl.create(:user2)
        @user.confirm_account
        @attr = {:email => @user.email, :password => @user.password }
      end
      
      it "should sign the user in" do
        @user.primary_email.should be_is_confirmed
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      
      it "should redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should log in using a second Confirmed email address" do
        ue = UserEmail.create(:user_id => @user.id, :email => "testing@hojo.com")
        ue.update_attributes(:confirmed => 'Y')
        user = User.find(@user.id)
        user.email_addresses.length.should == 2
        post :create, :session => @attr.merge(:email => ue.email)
        response.should redirect_to(user_path(@user))
      end

      it "should not log in using a second email, UNconfirmed address" do
        ue = UserEmail.create(:user_id => @user.id, :email => "testing@hojo.com")
        user = User.find(@user.id)
        user.email_addresses.length.should == 2
        post :create, :session => @attr.merge(:email => ue.email)
        response.should render_template('new')
      end

    end
  end
  
  describe "DELETE 'destroy'" do
    
    it "should sign a user out" do
      test_sign_in(FactoryGirl.create(:user2))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
    
  end
end
