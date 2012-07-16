require 'spec_helper'

describe "Compliments" do

  let(:founder) {FactoryGirl.create(:founder)}
  
  before(:each) do
    @relation = Relation.COWORKER
    visit new_shell_path
    fill_in "Email", :with => founder.email
    fill_in "Password", :with => founder.password
    click_button
  end
  
  describe "quick validation test" do
    it "should be at application root" do
      get '/'
      response.should have_selector("title", :content => "Compliment Karma Application")
    end
  end

  describe "send compliment from an unconfirmed user profile" do
    before(:each) do
      @user = FactoryGirl.create(:unconfirmed_user)
      visit login_path
      fill_in "Work Email", :with => @user.email
      fill_in "Password", :with => @user.password
      click_button
      response.should have_selector("title", :content => "Profile")
      @user.account_status.should eq(AccountStatus.UNCONFIRMED)
    end

    it "should not generate a compliment from an unconfirmed user" do
      lambda do
        fill_in "To", :with => "attaboy@goodjob.com" 
        fill_in "Skill", :with => "tennis"
        fill_in "Comment", :with => "Awesome job at the meet yesterday"
        select "Coworker to Coworker", :from => "compliment_compliment_type_id"
        click_button
      end.should_not change(Compliment, :count).by(1)
    end

  end
  
  describe "send compliment from user profile" do
    before(:each) do
      @user = FactoryGirl.create(:user2)
      visit login_path
      fill_in "Work Email", :with => @user.email
      fill_in "Password", :with => @user.password
      click_button
      response.should have_selector("title", :content => "Profile")
    end

    it "should should generate a compliment from a signed in user profile" do
      lambda do
        fill_in "To", :with => "attaboy@goodjob.com" 
        fill_in "Skill", :with => "tennis"
        fill_in "Comment", :with => "Awesome job at the meet yesterday"
        select "Coworker to Coworker", :from => "compliment_compliment_type_id"
        click_button
      end.should change(Compliment, :count).by(1)
      c = Compliment.last
      c.sender_user_id.should eq(@user.id)
      c.compliment_type.should eq(ComplimentType.PROFESSIONAL_TO_PROFESSIONAL)
    end

    it "should return to the user profile" do
      r = Relation.first
      fill_in "To", :with => "attaboy@goodjob.com"
      fill_in "Skill", :with => "tennis"
      fill_in "Comment", :with => "Awesome job at the meet yesterday"
      select "Coworker to Coworker", :from => "compliment_compliment_type_id"
      click_button
      response.should have_selector('title', :content => 'Profile')
    end
    
    describe "to an unregistered user" do
      before(:each) do
        @receiver_email = "attaboy@goodjob.com" 
        lambda do
          fill_in "To", :with => @receiver_email
          fill_in "Skill", :with => "tennis"
          fill_in "Comment", :with => "Awesome job at the meet yesterday"
          select "Coworker to Coworker", :from => "compliment_compliment_type_id"
          click_button
        end.should change(Compliment, :count).by(1)
        @compliment = Compliment.last
      end
      
      it "should have the correct attributes" do
        @compliment.sender_email.should eq(@user.email)
        @compliment.receiver_email.should eq(@receiver_email)
        @compliment.sender_user_id.should eq(@user.id)
        @compliment.receiver_user_id.should eq(nil)
        @compliment.compliment_status.should eq(ComplimentStatus.PENDING_RECEIVER_REGISTRATION)
        @compliment.visibility.should eq(Visibility.SENDER_AND_RECEIVER)
      end
    end
    
    describe "to an external unconfirmed user" do
      let(:receiver) {FactoryGirl.create(:unconfirmed_user3)}
      before(:each) do
        lambda do
          fill_in "To", :with => receiver.email
          fill_in "Skill", :with => "tennis"
          fill_in "Comment", :with => "Awesome job at the meet yesterday"
          select "Coworker to Coworker", :from => "compliment_compliment_type_id"
          click_button
        end.should change(Compliment, :count).by(1)
        @compliment = Compliment.last
      end
      
      it "should have the correct attributes" do
        @compliment.sender_email.should eq(@user.email)
        @compliment.receiver_email.should eq(receiver.email)
        @compliment.sender_user_id.should eq(@user.id)
        @compliment.receiver_user_id.should eq(receiver.id)
        @compliment.compliment_status.should eq(ComplimentStatus.PENDING_RECEIVER_CONFIRMATION)
        @compliment.visibility.should eq(Visibility.SENDER_AND_RECEIVER)
      end
    end
    
    describe "to a internal unconfirmed user" do
      let(:receiver) {FactoryGirl.create(:unconfirmed_user)}
      before(:each) do
        lambda do
          fill_in "To", :with => receiver.email
          fill_in "Skill", :with => "tennis"
          fill_in "Comment", :with => "Awesome job at the meet yesterday"
          select "Coworker to Coworker", :from => "compliment_compliment_type_id"
          click_button
        end.should change(Compliment, :count).by(1)
        @compliment = Compliment.last
      end
      
      it "should have the correct attributes" do
        @compliment.sender_email.should eq(@user.email)
        @compliment.receiver_email.should eq(receiver.email)
        @compliment.sender_user_id.should eq(@user.id)
        @compliment.receiver_user_id.should eq(receiver.id)
        @compliment.compliment_status.should eq(ComplimentStatus.PENDING_RECEIVER_CONFIRMATION)
        @compliment.visibility.should eq(Visibility.EVERYBODY)
      end
    end
    
    describe "to an external confirmed user without an existing relationship" do
      let(:receiver) {FactoryGirl.create(:user)}
      before(:each) do
         lambda do
           fill_in "To", :with => receiver.email
           fill_in "Skill", :with => "tennis"
           fill_in "Comment", :with => "Awesome job at the meet yesterday"
           select "Coworker to Coworker", :from => "compliment_compliment_type_id"
           click_button
         end.should change(Compliment, :count).by(1)
         @compliment = Compliment.last
       end

       it "should have the correct attributes" do
         @compliment.sender_email.should eq(@user.email)
         @compliment.receiver_email.should eq(receiver.email)
         @compliment.sender_user_id.should eq(@user.id)
         @compliment.receiver_user_id.should eq(receiver.id)
         @compliment.compliment_status.should eq(ComplimentStatus.ACTIVE)
         @compliment.visibility.should eq(Visibility.SENDER_AND_RECEIVER)
       end
       
       it "should create a NOT_ACCEPTED relationship" do
         r = Relationship.get_relationship(@user, receiver)
         r.should_not be_nil
         r.relationship_status.should eq(RelationshipStatus.PENDING)
         r.visibility.should eq(Visibility.SENDER_AND_RECEIVER)
       end
    end
    
    describe "to an external confirmed user with accepted relationship where default visibility is SENDER_AND_RECEIVER" do
      let(:receiver) {FactoryGirl.create(:user)}
      before(:each) do
        @relationship = Relationship.create(:user_1_id => @user.id,
                                            :user_2_id => receiver.id,
                                            :relationship_status_id => RelationshipStatus.ACCEPTED.id)
        lambda do
          fill_in "To", :with => receiver.email
          fill_in "Skill", :with => "tennis"
          fill_in "Comment", :with => "Awesome job at the meet yesterday"
          select "Coworker to Coworker", :from => "compliment_compliment_type_id"
          click_button
        end.should change(Compliment, :count).by(1)
        @compliment = Compliment.last
      end

      it "should have the correct attributes" do
       @compliment.sender_email.should eq(@user.email)
       @compliment.receiver_email.should eq(receiver.email)
       @compliment.sender_user_id.should eq(@user.id)
       @compliment.receiver_user_id.should eq(receiver.id)
       @compliment.compliment_status.should eq(ComplimentStatus.ACTIVE)
       @compliment.visibility.should eq(Visibility.SENDER_AND_RECEIVER)
      end
    end
    
    describe "to an external confirmed user with accepted relationship where default visibility is EVERYBODY" do
      let(:receiver) {FactoryGirl.create(:user)}
      before(:each) do
        @relationship = Relationship.create(:user_1_id => @user.id,
                                            :user_2_id => receiver.id,
                                            :relationship_status_id => RelationshipStatus.ACCEPTED.id,
                                            :default_visibility_id => Visibility.EVERYBODY.id)
        lambda do
          fill_in "To", :with => receiver.email
          fill_in "Skill", :with => "tennis"
          fill_in "Comment", :with => "Awesome job at the meet yesterday"
          select "Coworker to Coworker", :from => "compliment_compliment_type_id"
          click_button
        end.should change(Compliment, :count).by(1)
        @compliment = Compliment.last
      end

      it "should have the correct attributes" do
       @compliment.sender_email.should eq(@user.email)
       @compliment.receiver_email.should eq(receiver.email)
       @compliment.sender_user_id.should eq(@user.id)
       @compliment.receiver_user_id.should eq(receiver.id)
       @compliment.compliment_status.should eq(ComplimentStatus.ACTIVE)
       @compliment.visibility.should eq(Visibility.EVERYBODY)
      end
    end
    
    describe "to an internal confirmed user" do
      let(:receiver) {FactoryGirl.create(:user3)}
      before(:each) do
         lambda do
           fill_in "To", :with => receiver.email
           fill_in "Skill", :with => "tennis"
           fill_in "Comment", :with => "Awesome job at the meet yesterday"
           select "Coworker to Coworker", :from => "compliment_compliment_type_id"
           click_button
         end.should change(Compliment, :count).by(1)
         @compliment = Compliment.last
       end

       it "should have the correct attributes" do
         @compliment.sender_email.should eq(@user.email)
         @compliment.receiver_email.should eq(receiver.email)
         @compliment.sender_user_id.should eq(@user.id)
         @compliment.receiver_user_id.should eq(receiver.id)
         @compliment.compliment_status.should eq(ComplimentStatus.ACTIVE)
         @compliment.visibility.should eq(Visibility.EVERYBODY)
       end

      it "should create a ACCEPTED relationship" do
        r = Relationship.get_relationship(@user, receiver)
        r.should_not be_nil
        r.relationship_status.should eq(RelationshipStatus.ACCEPTED)
        r.visibility.should eq(Visibility.EVERYBODY)
      end
    end
    
    describe "failure" do
      it "should not create a new compliment" do
        r = Relation.first
        lambda do
          fill_in "To", :with => "attaboy@goodjob.com" 
          fill_in "Skill", :with => ""
          fill_in "Comment", :with => "Awesome job at the meet yesterday"
          select "Coworker to Coworker", :from => "compliment_compliment_type_id"
          click_button
        end.should_not change(Compliment, :count)
      end
      
      it "should return to the user profile" do
        r = Relation.first
        fill_in "To", :with => "attaboy@goodjob.com" 
        fill_in "Skill", :with => ""
        fill_in "Comment", :with => "Awesome job at the meet yesterday"
        select "Coworker to Coworker", :from => "compliment_compliment_type_id"
        click_button
        response.should have_selector('title', :content => 'Profile')
      end
    end
    
  end
  
  describe "associate pending compliments" do
    let(:userx) {FactoryGirl.create(:user)}
    
    it "should associate a compliment with a user when logged in" do
      visit login_path
      fill_in "Work Email", :with => userx.email
      fill_in "Password", :with => userx.password
      click_button
      response.should have_selector("title", :content => "Profile")
      
      lambda do
        fill_in "To", :with => "jimbob@godaddy.com"
        fill_in "Skill", :with => "Ruby on Rails"
        fill_in "Comment", :with => "You are awesome"
        select "Coworker to Coworker", :from => "compliment_compliment_type_id"
        click_button
      end.should change(Compliment, :count).by(1)
      c = Compliment.last
      c.sender_user_id.should eq(userx.id)
      c.compliment_status.should eq(ComplimentStatus.PENDING_RECEIVER_REGISTRATION)
    end
    
  end
  
  describe "attach compliments to receiver on signup" do
    let(:unconfirmed_user) {FactoryGirl.create(:unconfirmed_user)}
    let(:user) {FactoryGirl.create(:user)}
    
    before(:each) do
      @receiver = "test_sender@example.com"
      @compliment_attr = {
        :sender_email => user.email,
        :receiver_email => @receiver,
        :skill_id => Skill.first.id,
        :comment => "awesome job",
        :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
      }
      
      visit signup_path
      fill_in "Work Email", :with => @receiver
      fill_in "Full Name", :with => "test user mcgee"
      fill_in "Password", :with => "1234 on the floor"
    end
    
    describe "that are pending receiver registration" do
      
      it "should set the receiver id upon confirmation" do
        Compliment.create(@compliment_attr)
        click_button
        @user = User.last
        c = Compliment.find_all_by_receiver_email(@receiver)
        c.size.should eq(1)
        c[0].receiver_user_id.should eq(@user.id)
      end
      
      it "should find PENDING_RECEIVER_REGISTRATION and set the status to PENDING_RECEIVER_CONFIRMATION" do
        Compliment.create(@compliment_attr.merge(
                          :compliment_status_id => ComplimentStatus.PENDING_RECEIVER_REGISTRATION.id,
                          :sender_email => user.email))
        click_button
        @user = User.last
        c = Compliment.find_all_by_receiver_email(@receiver)
        c.size.should eq(1)
        c[0].receiver_user_id.should eq(@user.id)
        c[0].compliment_status.should eq(ComplimentStatus.PENDING_RECEIVER_CONFIRMATION)
      end
      
      it "should ignore PENDING_RECEIVER_CONFIRMATION" do
        Compliment.create(@compliment_attr.merge(
                  :compliment_status_id => ComplimentStatus.PENDING_RECEIVER_CONFIRMATION.id,
                  :sender_email => user.email))
        click_button
        @user = User.last
        c = Compliment.find_all_by_receiver_email(@receiver)
        c.size.should eq(1)
        c[0].receiver_user_id.should eq(@user.id)
        c[0].compliment_status.should eq(ComplimentStatus.PENDING_RECEIVER_CONFIRMATION)
      end
      
    end
    
  end

end
