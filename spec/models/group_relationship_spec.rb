require 'spec_helper'

describe GroupRelationship do
	let(:user){FactoryGirl.create(:user)}
	let(:user2){FactoryGirl.create(:user2)}
	# let(:user3){FactoryGirl.create(:user3}

	before(:each) do
		@pro = Group.get_professional_group(user)
		@soc = Group.get_social_group(user)
		@new = Group.create!(:user_id => user.id, :name => 'New')
	end

	it "should create a new group relationship" do
		GroupRelationship.delete_all
		gr = GroupRelationship.create(:super_group_id => @pro.id, :sub_group_id => @soc.id)
		@pro.sub_group_relationships.count.should == 1
		@pro.super_group_relationships.count.should == 0
		@soc.sub_group_relationships.count.should == 0
		@soc.super_group_relationships.count.should == 1
	end

	it "should allow a group to be a sub of itself" do
		GroupRelationship.delete_all
		gr = GroupRelationship.create(:super_group_id => @pro.id, :sub_group_id => @pro.id)
		@pro.sub_group_relationships.count.should == 1
		@pro.super_group_relationships.count.should == 1
	end

	it "should not allow a group to have the same sub group more than once" do
		GroupRelationship.delete_all
		gr = GroupRelationship.create(:super_group_id => @pro.id, :sub_group_id => @soc.id)
		gr = GroupRelationship.create(:super_group_id => @pro.id, :sub_group_id => @soc.id)
		@pro.sub_group_relationships.count.should == 1
		@soc.super_group_relationships.count.should == 1
	end

	it "should allow the same sub group to be assigned to different super groups" do
		GroupRelationship.delete_all
		gr = GroupRelationship.create(:super_group_id => @pro.id, :sub_group_id => @new.id)
		gr = GroupRelationship.create(:super_group_id => @soc.id, :sub_group_id => @new.id)
		@new.super_group_relationships.count.should == 2
		@pro.sub_group_relationships.count.should == 1
		@soc.sub_group_relationships.count.should == 1
	end

	it "should not allow a group relationship between groups of different users" do
		GroupRelationship.delete_all
		# gr = GroupRelationship.all
		pro_g = Group.get_professional_group(user)
		soc2 = Group.get_social_group(user2)
		# soc2.super_group_relationships.count.should == 0
		gr = GroupRelationship.create(:super_group_id => pro_g.id, :sub_group_id => soc2.id)
		gr = GroupRelationship.where('sub_group_id = ? AND super_group_id = ?', soc2.id, pro_g.id)
		pro_g.sub_group_relationships.count.should == 0
		gr.count.should == 0
	end

	it "should not allow self relationship to be destroyed" do
		GroupRelationship.delete_all
		gr = GroupRelationship.create(:super_group_id => @pro.id, :sub_group_id => @pro.id)
		@pro.sub_group_relationships.count.should == 1
		gr.destroy
		@pro.sub_group_relationships.count.should == 1
	end

	it "should destroy the relationship" do
		GroupRelationship.delete_all
		gr = GroupRelationship.create(:super_group_id => @pro.id, :sub_group_id => @pro.id)
		gr2 = GroupRelationship.create(:super_group_id => @pro.id, :sub_group_id => @soc.id)
		@pro.sub_group_relationships.count.should == 2
		gr2.destroy
		@pro.sub_group_relationships.count.should == 1
	end

end
