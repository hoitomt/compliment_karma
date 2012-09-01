class ActionItemsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user
	before_filter :set_compliment_panel
  before_filter :get_confirmation_status, :except => [:new, :create]

	def index
		# Optimized but not a big savings. We need the user object on the UI anyway for the URL
		# @action_items = @user.action_items.joins("LEFT OUTER JOIN users on originating_user_id = users.id")
		# 										 .select("action_items.*, users.*")
		@action_items = @user.action_items
		@action_items_count = @action_items.count
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

    def get_confirmation_status
      @confirmed = @user.blank? ? false: @user.confirmed?
    end
end
