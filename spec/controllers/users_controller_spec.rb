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
      response.should render_template('show')# have_selector("title", :content => "Profile")
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
        s = Skill.all
        if s.size < 40
          40.times do |index|
            s << Skill.create!(:name => "skill #{index}")
          end
        end
        compliment_id = ComplimentType.PROFESSIONAL_TO_PROFESSIONAL.id
        10.times do |index|
          Compliment.create(:sender_email => user2.email,
                            :receiver_email => user3.email,
                            :skill_id => s[index].id,
                            :comment => "Nice work on my sweater",
                            :compliment_type_id => compliment_id,
                            :suppress_fulfillment => true )
        end
        # User 2 is following User 3
        Follow.create(:subject_user_id => user3.id, :follower_user_id => user2.id)

        # 10 compliments from User 3 to User
        10.times do |index|
          Compliment.create(:sender_email => user3.email,
                            :receiver_email => user.email,
                            :skill_id => s[index + 10].id,
                            :comment => "Nice work on my sweater",
                            :compliment_type_id => compliment_id,
                            :suppress_fulfillment => true )
        end

        # 10 compliments from User 3 to User 2
        10.times do |index|
          Compliment.create(:sender_email => user3.email,
                            :receiver_email => user2.email,
                            :skill_id => s[index + 20].id,
                            :comment => "Nice work on my sweater",
                            :compliment_type_id => compliment_id,
                            :suppress_fulfillment => true )
        end

        # Unconfirmed compliment
        10.times do |index|
          Compliment.create(:sender_email => user2.email,
                            :receiver_email => unconfirmed_user.email,
                            :skill_id => s[index + 30].id,
                            :comment => "Nice work on my sweater",
                            :compliment_type_id => compliment_id,
                            :suppress_fulfillment => true )
        end
        Compliment.all.count.should eq(40)
      end

      describe "as viewed by page owner: User 2 viewing User 2s page" do
        before(:each) do
          GroupRelationship.delete_all
          test_sign_in(user2)
          @user3_pro_group = Group.get_professional_group(user3)
          @user3_public_group = Group.get_public_group(user3)
          GroupRelationship.create!(:super_group_id => @user3_pro_group.id, 
                                    :sub_group_id => @user3_pro_group.id)
          GroupRelationship.create!(:super_group_id => @user3_public_group.id, 
                                    :sub_group_id => @user3_pro_group.id)
        end

        # Unknown Follower
        it "should have the correct number of Compliments in Karma Live" do
          # should see followed
          get :show, :id => user2
          assigns(:karma_live_items_count).should eq(31)
          c = Compliment.where('sender_email = ? and receiver_email = ?', user3.email, user2.email)
          c.count.should eq(10)
          cx = Compliment.where('sender_email = ? and receiver_email = ?', user3.email, user.email)
          cx.count.should eq(10)
        end

        it "should create the correct number of Update Histories" do
          uh2 = UpdateHistory.find_all_by_user_id(user2.id)
          uh2.count.should eq(11)
          uh3 = UpdateHistory.find_all_by_user_id(user3.id)
          uh3.count.should eq(12)
        end

        # it "should have the correct entries in menu" do
        #   # professional_path
        #   # social_path
        #   # received_compliments
        #   # sent_compliments
        #   # contacts
        #   get :show, :id => user2
        #   response.should have_selector(:a, :href => user_professional_profile_url(user2))
        # end
      end

      describe "as viewed by visitor: User 3 viewing User 2s page" do
        before(:each) do
          GroupRelationship.delete_all
          test_sign_in(user3)
          @user2_pro_group = Group.get_professional_group(user2)
          @user2_public_group = Group.get_public_group(user2)
          GroupRelationship.create!(:super_group_id => @user2_pro_group.id, 
                                    :sub_group_id => @user2_pro_group.id)
          GroupRelationship.create!(:super_group_id => @user2_public_group.id, 
                                    :sub_group_id => @user2_pro_group.id)
        end

        it "should have the correct number of Compliments in Karma Live" do
          # should see followed
          get :show, :id => user2
          assigns(:karma_live_items_count).should eq(21)
          c = Compliment.where('sender_email = ? and receiver_email = ?', user3.email, user2.email)
          c.count.should eq(10)
          cu = Compliment.where('sender_email = ? and receiver_email = ? and compliment_status_id = ?', 
                                 user2.email, unconfirmed_user.email, 
                                 ComplimentStatus.PENDING_RECEIVER_CONFIRMATION.id)
          cu.count.should eq(10)
        end

        it "should create the correct number of Update Histories" do
          uh2 = UpdateHistory.find_all_by_user_id(user2.id)
          uh2.count.should eq(11)
          uh3 = UpdateHistory.find_all_by_user_id(user3.id)
          uh3.count.should eq(12)
        end

        it "should have the correct number of compliments after paging" do
          
        end
      end

      # Rule to test:
      # user is following user 2
      # user 3 is following user 2
      # When user 3 visit user's page, they should not see user 2's items unless
      # user 2's items are directly to/from user
      describe "should not show cross follows: User 3 view User 2s page" do
        before(:each) do
          test_sign_in(user3)
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
      response.should render_template('new')#have_selector("title", :content => @new_title )
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
      
      # Whitelist signup
      # it "should have the right title" do
      #   post :create, :user => @attr
      #   # response.should have_selector("title", :content => @new_title)
      #   # Private Beta redirects to root
      #   response.should redirect_to(root_url)
      # end
      
      # it "should render the 'new' page" do
      #   post :create, :user => @attr
      #   # response.should render_template('new')
      #   # Private Beta
      #   response.should render_template('invitation_mailer/beta_invitation')
      # end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@complimentkarma.com", 
                  :password => "foobar" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(User.last)
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

    describe "whitelist test" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@complimentkarma.com", 
                  :password => "foobar" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@groupon.com")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@bancbox.com")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@centro.net")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@searshc.com")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@acquitygroup.com")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@us.mcd.com")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@visa.com")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@gap.com")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@cat.com")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@sanofipasteur.com")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@gogoair.com")
        end.should change(User, :count).by(1)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr.merge(:email => "user@gspann.com")
        end.should change(User, :count).by(1)
      end
      
    end
    
    describe "name parsing" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@complimentkarma.com", 
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
        u.first_name.should == 'joe'
        u.middle_name.should == 'the'
        u.last_name.should == 'plumber'
      end

      it "should parse more than three names" do
        @attr[:name] = "thurston monroe howell the third"
        post :create, :user => @attr
        u = User.last
        u.first_name.should == 'thurston'
        u.middle_name.should == 'monroe'
        u.last_name.should == 'howell'
      end
    end
    
    describe "domain parsing" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@complimentkarma.com", 
                  :password => "foobar" }
      end
      
      it "should parse the domain name into the domain name field" do
        post :create, :user => @attr
        u = User.last
        u.domain.should == 'complimentkarma.com'
      end
      
    end
    
  end
  
  describe "authentication of user pages" do
    
    before(:each) do
      @user = FactoryGirl.create(:user2)
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
        wrong_user = FactoryGirl.create(:user, :email => "user@groupon.com")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'show'" do
        get :show, :id => @user
        response.should be_success
      end

    end
    
  end

  describe "private beta" do
    before(:each) do
      @attr = {:name => "Nicole",
               :email => 'nicole@bancbox.com',
               :password => 'bancbox'}
    end

    it "should allow signup" do
      lambda do
        post :create, :user => @attr
      end.should change(User, :count).by(1)
    end

    # Whitelist Signup
    # it "should allow signup for capital letter domain" do
    #   lambda do
    #     post :create, :user => @attr.merge(:email => 'nicole@Bancbox.com')
    #   end.should_not change(User, :count).by(1)
    # end

    # it "should not allow signup for non-whitelist" do
    #   lambda do
    #     post :create, :user => @attr.merge(:email => 'nicole@gmail.com')
    #   end.should_not change(User, :count)
    # end
    
  end

  describe "view profiles" do
    let(:user2) { FactoryGirl.create(:user2) }
    let(:user3) { FactoryGirl.create(:user3) }

    before(:each) do
      GroupRelationship.delete_all
      @u3_pro_group = Group.get_professional_group(user3)
      @u3_soc_group = Group.get_social_group(user3)
      @u3_public_group = Group.get_public_group(user3)
      Contact.create!(:group_id => @u3_pro_group.id, :user_id => user2.id)
      test_sign_in(user2)
      gr = GroupRelationship.create(:sub_group_id => @u3_soc_group.id, 
                                    :super_group_id => @u3_soc_group.id)
      gr_x = GroupRelationship.where(:sub_group_id => @u3_soc_group.id)
      gr_x.length.should == 4
    end

    it "should allow visibility to the social profile" do
      # gr = GroupRelationship.create(:sub_group_id => @u3_soc_group.id, 
      #                               :super_group_id => @u3_public_group.id)
      # gr_x = GroupRelationship.where(:sub_group_id => @u3_soc_group.id)
      # gr_x.length.should == 2
      get :social_profile, {:id => user3.id, :format => 'js'}
      assigns(:valid_visitor).should == true
      response.should be_success
    end

    it "should not allow visiblity to the social profile" do
      c = @u3_soc_group.contacts
      c.length == 0
      get :social_profile, {:id => 3, :format => 'js'}
      assigns(:valid_visitor).should == false
      response.should be_success
    end

    it "should allow visiblity to the social profile for self" do
      c = @u3_soc_group.contacts
      c.length == 0
      get :social_profile, {:id => user2.id, :format => 'js'}
      assigns(:valid_visitor).should == true
      response.should be_success
    end

    it "should allow visiblity to the professional profile for self" do
      c = @u3_soc_group.contacts
      c.length == 0
      get :professional_profile, {:id => user2.id, :format => 'js'}
      assigns(:valid_visitor).should == true
      response.should be_success
    end
  end

  describe "view my updates" do 
    let(:user2) { FactoryGirl.create(:user2) }
    let(:user3) { FactoryGirl.create(:user3) }
    
  end

end
