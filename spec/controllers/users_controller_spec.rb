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
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user2) }
    let(:user3) { FactoryGirl.create(:user3) }
    let(:unconfirmed_user) { FactoryGirl.create(:unconfirmed_user) }
    
    describe "compliments" do
      before(:each) do
        UpdateHistory.delete_all
        # Confirmed compliment
        # 10 compliments from User 2 to User 3
        10.times do |index|
          Compliment.create(:sender_email => user2.email,
                            :receiver_email => user3.email,
                            :skill_id => Skill.first.id,
                            :comment => "Nice work on my sweater",
                            :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL,
                            :suppress_fulfillment => true )
        end
        # User 2 is following User 3
        Follow.create(:subject_user_id => user3.id, :follower_user_id => user2.id)

        # 10 compliments from User 3 to User
        10.times do |index|
          Compliment.create(:sender_email => user3.email,
                            :receiver_email => user.email,
                            :skill_id => Skill.first.id,
                            :comment => "Nice work on my sweater",
                            :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL,
                            :suppress_fulfillment => true )
        end

        # 10 compliments from User 3 to User 2
        10.times do |index|
          Compliment.create(:sender_email => user3.email,
                            :receiver_email => user2.email,
                            :skill_id => Skill.first.id,
                            :comment => "Nice work on my sweater",
                            :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL,
                            :suppress_fulfillment => true )
        end

        # Unconfirmed compliment
        10.times do |index|
          Compliment.create(:sender_email => user2.email,
                            :receiver_email => unconfirmed_user.email,
                            :skill_id => Skill.first.id,
                            :comment => "Nice work on my sweater",
                            :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL,
                            :suppress_fulfillment => true )
        end
        Compliment.all.count.should eq(40)
      end

      describe "as viewed by page owner: User 2 viewing User 2s page" do
        before(:each) do
          test_sign_in(user2)
        end

        it "should have the correct number of Compliments in Karma Live" do
          # should see followed
          get :show, :id => user2
          assigns(:karma_live_items_count).should eq(20)
          c = Compliment.where('sender_email = ? and receiver_email = ?', user3.email, user2.email)
          c.count.should eq(10)
          cx = Compliment.where('sender_email = ? and receiver_email = ?', user3.email, user.email)
          cx.count.should eq(10)
        end

        it "should create the correct number of Update Histories" do
          uh2 = UpdateHistory.find_all_by_user_id(user2.id)
          uh2.count.should eq(10)
          uh3 = UpdateHistory.find_all_by_user_id(user3.id)
          uh3.count.should eq(11)
        end

        it "should have the correct number of compliments after paging" do

        end
      end

      describe "as viewed by visitor: User 3 viewing User 2s page" do
        before(:each) do
          test_sign_in(user3)
        end

        it "should have the correct number of Compliments in Karma Live" do
          # should see followed
          get :show, :id => user2
          assigns(:karma_live_items_count).should eq(20)
          c = Compliment.where('sender_email = ? and receiver_email = ?', user3.email, user2.email)
          c.count.should eq(10)
          cu = Compliment.where('sender_email = ? and receiver_email = ? and compliment_status_id = ?', 
                                 user2.email, unconfirmed_user.email, 
                                 ComplimentStatus.PENDING_RECEIVER_CONFIRMATION.id)
          cu.count.should eq(10)
        end

        it "should create the correct number of Update Histories" do
          uh2 = UpdateHistory.find_all_by_user_id(user2.id)
          uh2.count.should eq(10)
          uh3 = UpdateHistory.find_all_by_user_id(user3.id)
          uh3.count.should eq(11)
        end

        it "should have the correct number of compliments after paging" do
          
        end
      end
    end
    
    describe "rewards" do
      before(:each) do
        Reward.delete_all
        rs_id = RewardStatus.complete.id
        4.times do |index|
          value = index * 25 + 25
          Reward.create(:receiver_id => user2.id, :presenter_id => user3.id, 
                        :value => value, :reward_status_id => rs_id)
        end
        3.times do |index|
          value = index * 25 + 25
          Reward.create(:receiver_id => user3.id, :presenter_id => user2.id, 
                        :value => value, :reward_status_id => rs_id)
        end
        Follow.create(:subject_user_id => user3.id, :follower_user_id => user2.id)
        test_sign_in(user2)
      end
      
      it "should have the correct number of Rewards in Karma Live for Followed user" do
        Reward.count.should eq(7)
        get :show, :id => user2
        assigns(:karma_live_items_count).should eq(3)
      end

      it "should have entered Update History" do
        UpdateHistory.find_all_by_user_id(user2.id).count.should eq(4)
        UpdateHistory.find_all_by_user_id(user3.id).count.should eq(4)
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

      it "should not show pages for unconfirmed users"
    end
    
  end

end
