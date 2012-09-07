class ContactsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user

	def create
		contact = Contact.new(params[:contact])
		contact.save
		redirect_to @user
	end

	def add_remove_contact
		contact = Contact.where(:group_id => params[:group_id], :user_id => params[:contact_user_id])
		if contact.blank?
			# add a new contact
		else
			# remove the contact
			# if the selection is the last matching entry for the specified user in that group, don't delete, 
			# prompt the user to delete properly
		end
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
