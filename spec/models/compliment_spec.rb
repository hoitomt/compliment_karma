require 'spec_helper'

describe Compliment do
  let(:user){FactoryGirl.create(:user)}
  let(:unconfirmed_user){FactoryGirl.create(:unconfirmed_user)}

  before(:each) do
    @attr = {
      :receiver_email => "compliment@example.com",
      :sender_email => user.email,
      :skill_id => Skill.first.id,
      :comment => "I love what you did with our application",
      :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
    }
  end
  
  it "should respond to relation" do
    c = Compliment.new
    c.should respond_to(:relation)
  end
  
  it "should respond to compliment status" do
    c = Compliment.new
    c.should respond_to(:compliment_status)
  end

  it "should create a new instance given valid attributes" do
    Compliment.create!(@attr)
  end
  
  it "should require a receiver email" do
    c = Compliment.new(@attr.merge(:receiver_email => ""))
    c.should_not be_valid
  end

  it "should require a valid receiver email" do
    c = Compliment.new(@attr.merge(:receiver_email => "jo mamma"))
    c.should_not be_valid
  end
  
  it "should require a sender email" do
    c = Compliment.new(@attr.merge(:sender_email => ""))
    c.should_not be_valid
  end
  
  it "should require a valid sender email" do
    c = Compliment.new(@attr.merge(:sender_email => "jo daddy"))
    c.should_not be_valid
  end

  it "should require a confirmed sender" do
    c = Compliment.new(@attr.merge(:sender_email => unconfirmed_user.email))
    c.should_not be_valid
  end
  
  it "should require a skill" do
    c = Compliment.new(@attr.merge(:skill_id => ""))
    c.should_not be_valid
  end
  
  it "should require a comment" do
    c = Compliment.new(@attr.merge(:comment => ""))
    c.should_not be_valid    
  end
  
  it "should reject a comment that is too long" do
    long_comment = "q" * 201
    c = Compliment.new(@attr.merge(:comment => long_comment))
    c.should_not be_valid
  end
  
  describe "compliment status" do
    
    it "should assign the correct compliment status for confirmed sender" do
      c = Compliment.create!(@attr.merge(:sender_email => user.email))
      c.compliment_status.should eq(ComplimentStatus.PENDING_RECEIVER_REGISTRATION)
    end

  end
  
  describe "parsing values on create" do
    let(:user) {FactoryGirl.create(:user)}
  
    it "should add the sender domain on create" do
      c = Compliment.create!(@attr)
      c.sender_domain.should eq(user.domain)
    end
  
    it "should add the receiver domain on create" do
      c = Compliment.create!(@attr)
      c.receiver_domain.should eq('example.com')
    end
  
    it "should add the sender user id on create" do
      c = Compliment.create!(@attr.merge(:sender_email => user.email))
      c.sender_user_id.should eq(user.id)
    end
  end
  
  describe "my companies" do
    let(:user) {FactoryGirl.create(:user2)}
    let(:user3) {FactoryGirl.create(:user3)}

    it "should return the correct number of compliments for other sender/receiver" do
      lambda do
        10.times do |index|
          s = Skill.find_by_id(index) || Skill.create(:name => "skill #{index}")
          Compliment.create(@attr.merge(:sender_email => user.email, 
                                        :receiver_email => user3.email,
                                        :skill_id => s.id))
        end
      end.should change(Compliment, :count).by(10)
      
      my_company = Compliment.internal_coworkers(user)
      only_mine = Compliment.only_mine(user)
      my_company.count.should eq(10)
      only_mine.count.should eq(10)
    end
    
    it "should return the correct number of compliments for user as sender" do
      5.times do|index|
        s = Skill.find_by_id(index) || Skill.create(:name => "skill #{index}")
        Compliment.create(@attr.merge(:sender_email => user.email, :skill_id => s.id))
      end
      my_company = Compliment.internal_coworkers(user)
      only_mine = Compliment.only_mine(user)
      my_company.count.should eq(0) # The relationships have not been accepted
      only_mine.count.should eq(5)
    end
  end
  
  describe "only mine" do
    let(:user) {FactoryGirl.create(:user2)}

    it "should return the correct number of compliments for other sender/receiver" do
      10.times do |index|
        s = Skill.find_by_id(index) || Skill.create(:name => "skill #{index}")
        Compliment.create(@attr.merge(:sender_email => user.email, :skill_id => s.id))
      end
      my_company = Compliment.internal_coworkers(user)
      only_mine = Compliment.only_mine(user)
      my_company.count.should eq(0) # Visibility is Sender and Receiver
      only_mine.count.should eq(10) 
    end
    
    it "should return the correct number of compliments for user as sender" do
      5.times do |index|
        s = Skill.find_by_id(index) || Skill.create(:name => "skill #{index}")
        Compliment.create(@attr.merge(:sender_email => user.email, 
                                      :receiver_email => "mycoworker@examplex.com",
                                      :skill_id => s.id))
      end
      my_company = Compliment.internal_coworkers(user)
      only_mine = Compliment.only_mine(user)
      my_company.count.should eq(0) # Visibility is Sender and Receiver
      only_mine.count.should eq(5)
    end
  end
  
  describe "external" do
    let(:external_user) {FactoryGirl.create(:user2)}
    let(:user) {FactoryGirl.create(:user)}
    
    it "should return 0 compliments for unaccepted relationship" do
      10.times do |index|
        s = Skill.find_by_id(index) || Skill.create(:name => "skill #{index}")
        Compliment.create(@attr.merge(:sender_email => user.email, :skill_id => s.id))
      end
      external = Compliment.external_colleagues(user)
      external.count.should eq(0) # Visibility is Sender and Receiver
    end
    
    it "should return 10 compliments for accepted relationship" do
      Relationship.create(:user_1_id => external_user.id, :user_2_id => user.id, 
                          :relationship_status_id => RelationshipStatus.ACCEPTED.id,
                          :default_visibility_id => Visibility.EVERYBODY.id)
      10.times do |index|
        s = Skill.find_by_id(index) || Skill.create(:name => "skill #{index}")
        Compliment.create(@attr.merge(:receiver_email => user.email, 
                                      :sender_email => external_user.email,
                                      :skill_id => s.id))
      end
      external = Compliment.external_colleagues(user)
      external.count.should eq(10) # Visibility is Everybody after accept
    end
    
  end
  
  describe "relationship" do
    it "should create a 'NOT ACCEPTED' relationship if a user sends compliment to user" do
      external_user = FactoryGirl.create(:user2)
      lambda do
        c = Compliment.create(@attr.merge(:sender_email => user.email, 
                                          :receiver_email => external_user.email,
                                          :relation_id => 2))
      end.should change(Relationship, :count).by(1)
      r = Relationship.last
      r.user_1_id.should eq(user.id)
      r.user_2_id.should eq(external_user.id)
      r.relationship_status.should eq(RelationshipStatus.PENDING)
    end
    
    it "should create an 'ACCEPTED' relationship if a user sends compliment to user" do
      user2 = FactoryGirl.create(:user2)
      user3 = FactoryGirl.create(:user3)
      lambda do
        c = Compliment.create(@attr.merge(:sender_email => user2.email, 
                                          :receiver_email => user3.email,
                                          :relation_id => 1))
      end.should change(Relationship, :count).by(1)
      r = Relationship.last
      r.user_1_id.should eq(user2.id)
      r.user_2_id.should eq(user3.id)
      r.relationship_status.should eq(RelationshipStatus.ACCEPTED)
    end
    
    it "should not create a relationship if a user sends compliment to a non user" do
      external_user = FactoryGirl.create(:user2)
      lambda do
        c = Compliment.create(@attr.merge(:sender_email => user.email,
                                          :relation_id => 2))
      end.should_not change(Relationship, :count).by(1)
    end
    
  end
  
  describe "update history" do
    it "should create update history for receiver" do
      UpdateHistory.delete_all
      c = Compliment.create(@attr)
      uh = UpdateHistory.find_by_user_id(c.receiver_user_id)
      uh.should_not be_nil
      uh.update_history_type_id.should eq(UpdateHistoryType.Received_Compliment.id)
    end
  end

  describe "compliment from api" do
    let(:user) {FactoryGirl.create(:user)}
    let(:user2) {FactoryGirl.create(:user2)}
    let(:user3) {FactoryGirl.create(:user3)}
    let(:dummy) {User.find_by_email('dummy@example.org')}

    before(:each) do
      @params = {
        'from' => user2.email,
        'To' => user3.email,
        'body-plain' => "Great Job \r\n^ruby on rails^\r\nThanks, Mike",
        'stripped-text' => "Great Job ^ruby on rails^ Thanks, Mike"
      }
      @receiver_email = user3.email
    end

    it "should create a Pro to Pro compliment with the correct attributes" do
      c = Compliment.new
      lambda do
        c.create_from_api(@receiver_email, @params)
      end.should change(Compliment, :count).by(1)
      c.skill_id.should eq(Skill.find_by_name('ruby on rails').id)
      c.compliment_type_id.should eq(ComplimentType.PROFESSIONAL_TO_PROFESSIONAL.id)
    end

    it "should create a Pro to Personal compliment with the correct attributes" do
      @params['To'] = user.email
      c = Compliment.new
      @receiver_email = user.email
      lambda do
        c.create_from_api(@receiver_email, @params)
      end.should change(Compliment, :count).by(1)
      c.skill_id.should eq(Skill.find_by_name('ruby on rails').id)
      c.compliment_type_id.should eq(ComplimentType.PROFESSIONAL_TO_PERSONAL.id)
    end

    it "should create a Personal to Pro compliment with the correct attributes" do
      @params['from'] = user.email
      c = Compliment.new
      lambda do
        c.create_from_api(@receiver_email, @params)
      end.should change(Compliment, :count).by(1)
      c.skill_id.should eq(Skill.find_by_name('ruby on rails').id)
      c.compliment_type_id.should eq(ComplimentType.PERSONAL_TO_PROFESSIONAL.id)
    end

    it "should create a Personal to Personal compliment with the correct attributes" do
      @params['from'] = user.email
      @params['To'] = dummy.email
      c = Compliment.new
      @receiver_email = dummy.email
      lambda do
        c.create_from_api(@receiver_email, @params)
      end.should change(Compliment, :count).by(1)
      c.skill_id.should eq(Skill.find_by_name('ruby on rails').id)
      c.compliment_type_id.should eq(ComplimentType.PERSONAL_TO_PERSONAL.id)
    end

    it "should not create a compliment where the skill matches a compliment type" do
      c = Compliment.new
      @params['body-plain'] = "Great Job ^professional to professional^ Thanks, Mike"
      lambda do
        c.create_from_api(@receiver_email, @params)
      end.should change(Compliment, :count).by(1)
      s = Skill.where('lower(name) = ?', 'professional to professional')
      s.length.should eq(0)
      c.skill_id.should eq(Skill.UNDEFINED.id)
      c.compliment_type_id.should eq(ComplimentType.PROFESSIONAL_TO_PROFESSIONAL.id)
    end

  end

  describe "Karma Live compliments" do
    let(:ck) {FactoryGirl.create(:user2)}
    let(:groupon) {FactoryGirl.create(:groupon_user)}
    let(:sears) {FactoryGirl.create(:sears_user)}
    let(:dummy) {User.find_by_email('dummy@example.org')}

    before(:each) do
      Compliment.create(:receiver_email => ck.email,
                        :sender_email => groupon.email,
                        :skill_id => Skill.first.id,
                        :comment => "ComplimentKarma to Groupon",
                        :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
      )
      Compliment.create(:receiver_email => ck.email,
                        :sender_email => sears.email,
                        :skill_id => Skill.first.id,
                        :comment => "ComplimentKarma to Sears",
                        :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
      )
      Compliment.create(:receiver_email => sears.email,
                        :sender_email => ck.email,
                        :skill_id => Skill.first.id,
                        :comment => "Sears to ComplimentKarma",
                        :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
      )
      Compliment.create(:receiver_email => groupon.email,
                        :sender_email => ck.email,
                        :skill_id => Skill.first.id,
                        :comment => "Gropuon to ComplimentKarma",
                        :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
      )
    end

    it "should not show sears compliments to groupon users through ComplimentKarma Follow" do
      # Scenario from production with Aman, Shahed, and Sheela
      Follow.create(:subject_user_id => sears.id, :follower_user_id => ck.id)
      Follow.create(:subject_user_id => ck.id, :follower_user_id => groupon.id)
      c = Compliment.all_compliments_from_followed_in_domain(groupon)
      c.size.should == 2
      c.first.sender_email.should_not match(/searshc.com/)
      c.first.receiver_email.should_not match(/searshc.com/)
      c.last.sender_email.should_not match(/searshc.com/)
      c.last.receiver_email.should_not match(/searshc.com/)
    end

    it "should show sears and groupon compliments to ComplimentKarma" do
      # Scenario from production with Aman, Shahed, and Sheela
      Follow.create(:subject_user_id => sears.id, :follower_user_id => ck.id)
      Follow.create(:subject_user_id => groupon.id, :follower_user_id => ck.id)
      Follow.create(:subject_user_id => ck.id, :follower_user_id => groupon.id)
      c = Compliment.all_compliments_from_followed_in_domain(ck)
      c.size.should == 4
    end

  end

end
