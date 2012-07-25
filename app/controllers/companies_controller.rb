class CompaniesController < ApplicationController
	before_filter :authenticate

	def update
		@user = User.find(params[:user_id])
		@user.update_attributes(params[:user]) if params[:user][:photo]
		@company = @user.company if @user
		@company.update_attributes(params[:company])
		redirect_to @user
	end

	private
    def authenticate
      deny_access unless signed_in?
    end
end
