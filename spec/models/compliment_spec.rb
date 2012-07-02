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
      :compliment_type_id => ComplimentType.COWORKER_TO_COWORKER
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
        10.times do
          Compliment.create(@attr.merge(:sender_email => user.email, :receiver_email => user3.email))
        end
      end.should change(Compliment, :count).by(10)
      
      my_company = Compliment.internal_coworkers(user)
      only_mine = Compliment.only_mine(user)
      my_company.count.should eq(10)
      only_mine.count.should eq(10)
    end
    
    it "should return the correct number of compliments for user as sender" do
      5.times do
        Compliment.create(@attr.merge(:sender_email => user.email))
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
      10.times do
        Compliment.create(@attr.merge(:sender_email => user.email))
      end
      my_company = Compliment.internal_coworkers(user)
      only_mine = Compliment.only_mine(user)
      my_company.count.should eq(0) # Visibility is Sender and Receiver
      only_mine.count.should eq(10) 
    end
    
    it "should return the correct number of compliments for user as sender" do
      5.times do
        Compliment.create(@attr.merge(:sender_email => user.email, :receiver_email => "mycoworker@examplex.com"))
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
      10.times do
        Compliment.create(@attr.merge(:sender_email => user.email))
      end
      external = Compliment.external_colleagues(user)
      external.count.should eq(0) # Visibility is Sender and Receiver
    end
    
    it "should return 10 compliments for accepted relationship" do
      Relationship.create(:user_1_id => external_user.id, :user_2_id => user.id, 
                          :relationship_status_id => RelationshipStatus.ACCEPTED.id,
                          :default_visibility_id => Visibility.EVERYBODY.id)
      10.times do
        Compliment.create(@attr.merge(:receiver_email => user.email, 
                                      :sender_email => external_user.email))
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
  
end
