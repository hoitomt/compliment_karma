require 'spec_helper'

describe ActionItemsController do
	render_views

	let(:user2){FactoryGirl.create(:user2)}
	let(:user3){FactoryGirl.create(:user3)}

	before(:each) do
    test_sign_in(user2)
    @attr = {
    	:user_id => user2.id,
    	:originating_user_id => user3.id,
    	:recognition_type_id => RecognitionType.COMPLIMENT.id,
    	:recognition_id => 1,
    	:action_item_type_id => ActionItemType.Authorize_Contact.id
    }
    @group = Group.get_professional_group(user2)
	end

	describe "accept" do
		before(:each) do
			@action_item = ActionItem.create(@attr)
			@attr_accept = {:groups => {@group.id => 'yes'}, :user_id => user2.id, 
										 :originator_user_id => user3.id, :id => @action_item.id}
		end

		it "should update complete to 'yes'" do
			post :accept, @attr_accept
			@action_item.reload
			@action_item.complete.should == "Y"
		end
	end

	describe "decline" do
		before(:each) do
			@attr_decline = {:groups => {@group.id => 'yes'}, :user_id => user2.id, 
									   	 :originator_user_id => user3.id }
      @attr_compliment = {
        :receiver_email => user2.email,
        :sender_email => user3.email,
        :skill_id => Skill.first.id,
        :comment => "I love what you did with our application",
        :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
      }
		end

		it "should update complete to 'yes'" do
      @action_item = ActionItem.create(@attr)
      post :decline, @attr_decline.merge(:id => @action_item.id)
      @action_item.reload
      @action_item.complete.should == "Y"
		end

    describe "compliment" do

      it "should create a compliment" do
        lambda do
          Compliment.create(@attr_compliment)
        end.should change(Compliment, :count).by(1)
      end

      it "should set the compliment status to declined" do
        c = Compliment.create(@attr_compliment)
        user2.action_items.count.should == 1
        ai = user2.action_items.first
        post :decline, @attr_decline.merge(:id => ai.id)
        c.reload
        c.compliment_status_id.should == ComplimentStatus.DECLINED.id
      end

    end

	end
end
