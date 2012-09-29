class ContactsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user

	def new
	end

	def pre_create
		@contact_user = User.find_by_id(params[:contact_user_id])
		if @contact_user.existing_contact?(@user)
			logger.info("Existing Contact")
			flash.now[:error] = "#{@contact_user.first_last} is already one of your contacts"
			render :error_display
		else
			@groups = current_user.groups
			@contact = Contact.new
		end
	end

	def create
		contact_user = User.find_by_id(params[:contact_user_id])
    groups = params[:groups]
    group_names = []
    contact_added = false
    error = false
    groups.try(:each) do |k,v|
      if v.downcase == 'yes'
        contact = Contact.new(:group_id => k, :user_id => contact_user.id)
        unless contact.save
        	error = true
        	errors = []
        	contact.errors.messages.each {|k, v| errors << "#{v.join("\n")}"}
        	flash.now[:error] = errors.join("\n")
        	break
        end
        contact_added = true
        group_names << Group.find_by_id(k).try(:name)
      end
    end

    if error
    	@error_container = 'results'
    	render 'contacts/error_display'
		elsif contact_added
			ui_vars
      flash.now[:notice] = "#{contact_user.full_name} has been added as a contact in the following groups: 
                        #{group_names.join(', ')}"
      render 'users/filter_contacts'
    else
    	render 'users/filter_contacts'
		end

	end

	def add_remove_contact
		update_groups(params)
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

	def update_groups(params)
		contact_user = get_contact_user(params)
		return if contact_user.blank?
		new_group_ids = get_new_group_ids(params)
		return if new_group_ids.blank?
		Contact.update_groups(@user, contact_user, new_group_ids)
	end

	def get_contact_user(params)
		contact_user = User.find_by_id(params[:contact_user_id])
		flash.now[:error] = "A contact must be specified" if contact_user.blank?
		return contact_user
	end

	def get_new_group_ids(params)
		contact_groups = params[:contact_group]
		if contact_groups.blank?
			flash.now[:error] = "A group must be specified"
			return
		end
		new_group_ids = contact_groups.collect{|k, v| k} || Array.new
		flash.now[:error] = "A group must be specified" if new_group_ids.blank?
		return new_group_ids
	end

	def decline
		@contact = Contact.find(params[:id])
		group_ids = @user.groups.collect{|g| g.id}
		contact_user = @contact.user
		matching_contacts = Contact.where('user_id = ? AND group_id in (?)', contact_user.id, group_ids)
		matching_contacts.destroy_all
		ui_vars
		flash.now[:notice] = "#{contact_user.first_last} has been removed from your contacts"
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
