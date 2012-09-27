class GroupsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user

	def update_super_group
		@groups = @user.groups
		new_super_group_ids = params[:super_group_ids].try(:keys) || Hash.new
		@group = Group.find(params[:id])
		@group.update_super_groups(new_super_group_ids)
		@group.reload
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
