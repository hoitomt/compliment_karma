class GroupsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user

	def update_super_group
		@groups = @user.groups
		@group = Group.find(params[:id])
		@super_group = Group.find(params[:super_group_id])
		existing_relationship = GroupRelationship.where(:sub_group_id => @group.id, :super_group_id => @super_group.id)
		if existing_relationship.blank?
			add_super_group
		else
			remove_super_group(existing_relationship.first)
		end
	end

	def add_super_group
		GroupRelationship.create(:sub_group_id => @group.id, :super_group_id => @super_group.id)
	end

	def remove_super_group(group_relationship)
		group_relationship.destroy
	end

	private
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:user_id])
      good_user = current_user?(@user)
      redirect_to(root_path) unless good_user
    end
end
