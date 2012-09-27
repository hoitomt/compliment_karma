require 'spec_helper'

describe GroupsController do
	render_views

	let(:user3){FactoryGirl.create(:user3)}

	before(:each) do
    test_sign_in(user3)
	end

	describe "update super group" do
		before(:each) do
			@pro_group = Group.get_professional_group(user3)
			@contacts_group = Group.get_contacts_group(user3)
			@params = {:user_id => user3.id,
								 :id => @pro_group.id
								}
		end

		it "should add contacts group visibility to the pro group" do
			format = mock("format")
			format.should_receive(:js)
			@params = @params.merge(:super_group_ids => {@contacts_group.id.to_s => "yes"})
			post :update_super_group, @params, :format => 'js'
			@pro_group.reload
			@pro_group.has_group_visibility?(@contacts_group).should == true
		end
	end

end
