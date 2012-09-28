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
										 :originator_id => user3.id, :id => @action_item.id}
		end

		it "should update complete to 'yes'" do
			post :accept, @attr_accept
			@action_item.reload
			@action_item.complete.should == "Y"
		end
	end

	describe "decline" do
		before(:each) do
			@action_item = ActionItem.create(@attr)
			@attr_accept = {:groups => {@group.id => 'yes'}, :user_id => user2.id, 
										 :originator_user_id => user3.id, :id => @action_item.id}
		end

		it "should update complete to 'yes'" do
		end

	end
end
