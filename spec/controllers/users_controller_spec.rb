require 'spec_helper'

describe UsersController do
  render_views
  
  before(:each) do
    @new_title = "Sign up"
    controller.class.skip_before_filter :shell_authenticate
  end
  
  describe "GET 'show'" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => "Profile")
    end
  end
    
  describe "User SHOW view variables" do
    let(:user2) { FactoryGirl.create(:user2) }
    let(:user3) { FactoryGirl.create(:user3) }
    let(:unconfirmed_user) { FactoryGirl.create(:unconfirmed_user) }
    
    describe "compliments" do
      before(:each) do
        UpdateHistory.delete_all
        # Confirmed compliment
        10.times do |index|
          Compliment.create(:sender_email => user2.email,
                            :receiver_email => user3.email,
                            :skill_id => Skill.first.id,
                            :comment => "Nice work on my sweater",
                            :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL )
        end
        Follow.create(:subject_user_id => user3.id, :follower_user_id => user2.id)

        # Unconfirmed compliment
        10.times do |index|
          Compliment.create(:sender_email => user2.email,
                            :receiver_email => unconfirmed_user.email,
                            :skill_id => Skill.first.id,
                            :comment => "Nice work on my sweater",
                            :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL )
        end
        Compliment.all.count.should eq(20)
        test_sign_in(user2)
      end

      it "should have the correct number of Compliments in Karma Live" do
        get :show, :id => user2
        assigns(:karma_live_items_count).should eq(10)
      end

      it "should create the correct number of Update Histories" do
        UpdateHistory.count.should eq(21)
      end
    end
    
    describe "rewards" do
      before(:each) do
        Reward.delete_all
        4.times do |index|
          value = index * 25 +25
          Reward.create(:receiver_id => user2.id, :presenter_id => user3.id, :value => value)
        end
        Follow.create(:subject_user_id => user3.id, :follower_user_id => user2.id)
        test_sign_in(user2)
      end
      
      it "should have the correct number of Rewards in Karma Live for Followed user" do
        Reward.count.should eq(4)
        r = Reward.last
        r.receiver.should eq(user2)
        get :show, :id => user2
        assigns(:karma_live_items_count).should eq(4)
      end

      it "should have entered Update History" do
        UpdateHistory.find_all_by_user_id(user3.id).count.should eq(5)
      end
    end
    
    describe "accomplishments" do
      before(:each) do
        user3.accomplishments << Accomplishment.ASPIRANT_BADGE
        user3.accomplishments << Accomplishment.NINJA_BADGE
        user3.accomplishments << Accomplishment.GRAND_MASTER_BADGE
        user2.accomplishments << Accomplishment.ASPIRANT_BADGE
        user2.save!
        user3.save!
        Follow.create(:subject_user_id => user3.id, :follower_user_id => user2.id)
        test_sign_in(user2)
      end
      
      it "should have the correct number of Accomplishments in Karma Live" do
        get :show, :id => user2
        assigns(:karma_live_items_count).should eq(3)
      end
      
      it "should have entered Update History" do
        UpdateHistory.find_all_by_user_id(user3.id).count.should eq(4)
      end
    end
    
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => @new_title )
    end
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      before(:each) do
        @attr = {:name => "", :email => "", :password => ""}
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => @new_title)
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com", 
                  :password => "foobar" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(invite_coworkers_path)
      end
      
      # it "should have a welcome message" do
      #   post :create, :user => @attr
      #   flash[:success].should =~ /welcome to compliment karma/i
      # end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
      
      it "should parse the name" do
        post :create, :user => @attr
        u = User.last
        u.first_name.should == 'New'
        u.last_name.should == 'User'
      end
    end
    
    describe "name parsing" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com", 
                  :password => "foobar" }
      end
      
      it "should parse the name" do
        post :create, :user => @attr
        u = User.last
        u.first_name.should == 'New'
        u.last_name.should == 'User'
      end
      
      it "should parse three names" do
        @attr[:name] = "joe the plumber"
        post :create, :user => @attr
        u = User.last
        u.first_name.should == 'Joe'
        u.middle_name.should == 'The'
        u.last_name.should == 'Plumber'
      end

      it "should parse more than three names" do
        @attr[:name] = "thurston monroe howell the third"
        post :create, :user => @attr
        u = User.last
        u.first_name.should == 'Thurston'
        u.middle_name.should == 'Monroe'
        u.last_name.should == 'Howell'
      end
    end
    
    describe "domain parsing" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com", 
                  :password => "foobar" }
      end
      
      it "should parse the domain name into the domain name field" do
        post :create, :user => @attr
        u = User.last
        u.domain.should == 'example.com'
      end
      
    end
    
  end
  
  describe "authentication of user pages" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    describe "for non-signed-in users" do
      it "should deny access to 'show'" do
        get :show, :id => @user
        response.should redirect_to(login_path)
      end
      
      it "should deny access to 'show'" do
        put :show, :id => @user, :user => {}
        response.should redirect_to(login_path)
      end
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        wrong_user = FactoryGirl.create(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'show'" do
        get :show, :id => @user
        response.should be_success
      end
    end
    
  end

end
