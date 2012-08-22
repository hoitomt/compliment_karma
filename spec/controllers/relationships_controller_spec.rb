require 'spec_helper'

describe RelationshipsController do
  render_views
  
  before(:each) do
    @new_title = "Sign up"
    controller.class.skip_before_filter :shell_authenticate
  end

  describe "Relationships" do
  	let(:ck){ FactoryGirl.create(:user2) }
  	let(:sears){ FactoryGirl.create(:sears_user) }
  	
		before(:each) do
			test_sign_in(ck)
			s = Skill.create(:name => "Test #{DateTime.now}")
			@compliment = Compliment.create(:sender_email => ck.email,
																		  :receiver_email => sears.email,
																		  :comment => "Testing your love for me",
																		  :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL,
																		  :skill_id => s.id )
			@relationship = Relationship.find_by_user_1_id(ck.id)
			@relationship.should_not be_nil
		end

		it "A new compliment email should have accept and decline buttons" do
			last_email.body.should have_selector('a', :href => accept_relationship_url(:id => @relationship.id))
			last_email.body.should have_selector('a', :href => decline_relationship_url(:id => @relationship.id))
		end

		it "should Approve the relationship" do
			@relationship.relationship_status.should == RelationshipStatus.PENDING
			get :accept, :id => @relationship.id
			r = Relationship.find(@relationship.id)
			r.relationship_status.should == RelationshipStatus.ACCEPTED
			c = Compliment.find(@compliment.id)
			c.compliment_status.should == ComplimentStatus.ACTIVE
			c.visibility.should == Visibility.EVERYBODY
		end

		it "should Decline the relationship" do
			@relationship.relationship_status.should == RelationshipStatus.PENDING
			get :decline, :id => @relationship.id
			r = Relationship.find(@relationship.id)
			r.relationship_status.should == RelationshipStatus.NOT_ACCEPTED
			c = Compliment.find(@compliment.id)
			c.compliment_status.should == ComplimentStatus.ACTIVE
			c.visibility.should == Visibility.SENDER_AND_RECEIVER
		end
	end

end
