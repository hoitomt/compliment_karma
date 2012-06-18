require 'spec_helper'

describe ComplimentsController do
  render_views
  
  before(:each) do
    controller.class.skip_before_filter :shell_authenticate
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      before(:each) do
        @attr = {
          :receiver_email => "",
          :sender_email => "",
          :skill_id => "",
          :comment => "",
          :relation_id => 1
        }
      end

      it "should not create a valid compliment" do
        lambda do
          post :create, :compliment => @attr, :request_page => "main"
        end.should_not change(Compliment, :count)
      end
      
      it "should post an error message" do
        post :create, :compliment => @attr, :request_page => "main"
        response.should redirect_to(root_path)
      end
      
      it "should not create an email message" do
        post :create, :compliment => @attr
        c = Compliment.last
        last_email.should be_nil
      end
      
      it "should route to the current user profile if sender is current confirmed user" do
        user = FactoryGirl.create(:user)
        post :create, :compliment => @attr.merge(:sender_email => user.email), :request_page => "user"
        response.should redirect_to(user)
      end
      
    end
    
    
    describe "compliment created by user to user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:user2) { FactoryGirl.create(:user2) }
      
      before(:each) do
        @attr = {
          :receiver_email => user2.email,
          :sender_email => user.email,
          :skill_id => Skill.first.id,
          :comment => "I love what you did with our application",
          :relation_id => 1
        }
      end
      
      it "should create a valid compliment" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count)
      end
      
      it "should create a compliment with a status of active" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count).from(0).to(1)
        c = Compliment.last
        c.compliment_status.should eq(ComplimentStatus.ACTIVE)
      end
      
      it "should attach the compliment to the sender and receiver" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count).from(0).to(1)
        c = Compliment.last
        c.sender_user_id.should eq(user.id)
        c.receiver_user_id.should eq(user2.id)
      end
      
      it "should create an outbound email" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count).from(0).to(1)
        last_email.from.should eq(["no-reply@complimentkarma.com"])
        last_email.to.should eq([user2.email])
        last_email.subject.should eq("You have received a compliment")
      end
    end
    
    describe "compliment created by user to unconfirmed user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:user2) { FactoryGirl.create(:unconfirmed_user) }
      
      before(:each) do
        @attr = {
          :receiver_email => user2.email,
          :sender_email => user.email,
          :skill_id => Skill.first.id,
          :comment => "I love what you did with our application",
          :relation_id => 1
        }
      end
      
      it "should create a valid compliment" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count)
      end
      
      it "should create a compliment with a status of pending receiver confirmation" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count).from(0).to(1)
        c = Compliment.last
        c.compliment_status.should eq(ComplimentStatus.PENDING_RECEIVER_CONFIRMATION)
      end
      
      it "should attach the compliment to the sender and receiver" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count).from(0).to(1)
        c = Compliment.last
        c.sender_user_id = user.id
        c.receiver_user_id = user2.id
      end
      
      it "should create an outbound email" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count).from(0).to(1)
        last_email.from.should eq(["no-reply@complimentkarma.com"])
        last_email.to.should eq([user2.email])
        last_email.subject.should eq("You have received a compliment")
        last_email.body.should have_selector('body', 
                  :content => "new_account_confirmation#{user2.new_account_confirmation_token}")
      end
      
    end

    describe "compliment created by user to unknown user" do
      let(:user) { FactoryGirl.create(:user) }
      
      before(:each) do
        @attr = {
          :receiver_email => "imastranger@example.com",
          :sender_email => user.email,
          :skill_id => Skill.first.id,
          :comment => "I love what you did with our application",
          :relation_id => 1
        }
      end
      
      it "should create a valid compliment" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count)
      end
      
      it "should create a compliment with a status of pending receiver registration" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count).from(0).to(1)
        c = Compliment.last
        c.compliment_status.should eq(ComplimentStatus.PENDING_RECEIVER_REGISTRATION)
      end
      
      it "should attach the message to the sender" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count).from(0).to(1)
        c = Compliment.last
        c.sender_user_id = user.id
      end
      
      it "should create an outbound email" do
        lambda do
          post :create, :compliment => @attr
        end.should change(Compliment, :count).from(0).to(1)
        last_email.from.should eq(["no-reply@complimentkarma.com"])
        last_email.to.should eq(["imastranger@example.com"])
        last_email.subject.should eq("You have received a compliment")
        last_email.body.should have_selector('a', :content => "Sign Up")
      end
    end

    describe "default relationship of compliments" do
      let(:company1_user1) {FactoryGirl.create(:user2)}
      let(:company1_user2) {FactoryGirl.create(:user3)}
      let(:company2_user1) {FactoryGirl.create(:user)}
      
      describe "internal to internal relationship" do
        
        before(:each) do
          @attr = {
            :receiver_email => company1_user1.email,
            :sender_email => company1_user2.email,
            :skill_id => Skill.first.id,
            :comment => "I love what you did with our application",
            :relation_id => Relation.COWORKER.id
          }
        end
        
        it "should be defaulted as Accepted" do
          lambda do
            post :create, :compliment => @attr
          end.should change(Compliment, :count).from(0).to(1)
          r = Relationship.last
          r.relationship_status.should eq(RelationshipStatus.ACCEPTED)
        end
        
      end
      
      describe "internal to external relationship" do
        
        before(:each) do
          @attr = {
            :receiver_email => company2_user1.email,
            :sender_email => company1_user2.email,
            :skill_id => Skill.first.id,
            :comment => "I love what you did with our application",
            :relation_id => Relation.CLIENT.id
          }
        end
        
        it "should be defaulted as Not Accepted for Client" do
          lambda do
            post :create, :compliment => @attr
          end.should change(Compliment, :count).from(0).to(1)
          r = Relationship.last
          r.relationship_status.should eq(RelationshipStatus.PENDING)
        end
      end
      
    end
      
    describe "default visibility of compliment" do
      let(:company1_user1) {FactoryGirl.create(:user2)}
      let(:company1_user2) {FactoryGirl.create(:user3)}
      let(:company2_user1) {FactoryGirl.create(:user)}
      
      describe "internal to internal compliment" do
        before(:each) do
          @attr = {
            :receiver_email => company1_user1.email,
            :sender_email => company1_user2.email,
            :skill_id => Skill.first.id,
            :comment => "I love what you did with our application",
            :relation_id => Relation.COWORKER.id
          }
        end
        
        it "should set the visibity of internal to internal to Everybody" do
          lambda do
            post :create, :compliment => @attr
          end.should change(Compliment, :count).from(0).to(1)
          c = Compliment.last
          c.visibility.should eq(Visibility.EVERYBODY)
        end          
      end
      
      describe "internal to external compliment" do
        before(:each) do
          @attr = {
            :receiver_email => company2_user1.email,
            :sender_email => company1_user2.email,
            :skill_id => Skill.first.id,
            :comment => "I love what you did with our application",
            :relation_id => Relation.COWORKER.id
          }
        end
        
        it "should set the visibility of internal to external to Sender and Receiver" do
          lambda do
            post :create, :compliment => @attr
          end.should change(Compliment, :count).from(0).to(1)
          c = Compliment.last
          c.visibility.should eq(Visibility.SENDER_AND_RECEIVER)            
        end
      end

    end

  end

end
