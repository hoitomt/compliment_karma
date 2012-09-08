class ContactsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user

	def create
		contact = Contact.new(params[:contact])
		contact.save
		redirect_to @user
	end

	def add_remove_contact
		contact_user = User.find_by_id(params[:contact_user_id])
		group = Group.find_by_id(params[:group_id])
		contact = Contact.where(:group_id => group.try(:id), :user_id => contact_user.try(:id))
		if !group.blank? && !contact_user.blank?
			if contact.blank?
				Contact.remove_declined_contact(contact_user, @user)
				@contact = Contact.create(:group_id => group.try(:id), :user_id => contact_user.try(:id))
			else
				# Find out how many groups the user is in
				contacts = contact_user.existing_contacts(@user)
				logger.info("Contacts from the user: #{contacts.length}")
				# if 2 or more then we can delete
				if contacts.length > 1
					contact.first.delete
					# Contact.find(contact.first.id).delete
				else
					flash.now[:error] = "You cannot remove a contact from their last group. 
															 Please delete the contact using the [x]"
				end
			end
		end
		ui_vars
		respond_to do |format|
			format.html { redirect_to @user }
			format.js { 
				if flash.now[:error].blank?
					render 'users/filter_contacts' 
				else
					render 'contacts/error_display'
				end
			}
		end
	end

	def decline
		@contact = Contact.find(params[:id])
		contact_user = @contact.user
		reset_contacts(contact_user)
		Contact.create_declined_contact(contact_user, @user)
		ui_vars
		respond_to do |format|
			format.html { redirect_to @user }
			format.js { render 'users/filter_contacts' }
		end
	end

	def reset_contacts(user)
		user.existing_contacts(@user).delete_all
	end

	def create_declined_contact(user)
	end

	def remove_declined_contact(user)

	end

	def ui_vars
		@groups = @user.groups
		@filter = params[:filter_id]
		@group_counts = Contact.group_counts(@user)
		@contacts = Contact.filtered_list(@user, @filter)
    @user_contacts_count = @user.contacts.includes(:user).uniq{|x| x.user_id}.count
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
