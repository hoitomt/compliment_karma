require 'spec_helper'

describe Group do
	let(:user2){FactoryGirl.create(:user2)}

	before(:each) do
		@attr = {:name => 'Test', :user_id => user2.id, :display_ind => 'Y'}
	end

	it "should create a valid group" do
		lambda do
			Group.create!(@attr)
		end.should change(Group, :count).by(1)
	end

	it "should attach to a public group" do
		pg = Group.get_public_group(user2)
		g = Group.create!(@attr)
		GroupRelationship.create(:sub_group_id => g.id, :super_group_id => pg.id)
		g.has_public_visibility?.should == true
	end

	it "should attach to all public groups" do
		g = Group.create!(@attr)
		g.attach_to_all_groups
		Group.public_group_list(user2).each do |sg|
			g.has_group_visibility?(sg).should == true
		end
	end

	it "should detach from all public groups" do
		g = Group.create!(@attr)
		g.attach_to_all_groups
		Group.public_group_list(user2).each do |sg|
			g.has_group_visibility?(sg).should == true
		end
		
		# puts g.super_group_relationships.collect{|sgr| sgr.super_group.name}
		g.detach_from_all_groups
		g.reload
		Group.public_group_list(user2).each do |sg|
			if sg.id != g.id
				# puts sg.name
				g.has_group_visibility?(sg).should_not == true
			end
		end
		# should still be visible to self
		g.has_group_visibility?(g).should == true
	end

end
