class ContactsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user

	def create
		contact = Contact.new(params[:contact])
		contact.save
		redirect_to @user
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
