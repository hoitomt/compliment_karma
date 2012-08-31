class UserEmailsController < ApplicationController
	before_filter :authenticate
	before_filter :get_email_addresses

	def index
		@user_email = UserEmail.new	
	end

	def new
		@user_email = UserEmail.new
	end

	def create
		@user_email = UserEmail.new(params[:user_email])
		@user_email.user_id = current_user.id
		if @user_email.save
			@user_email.associate_compliments
			@user_email.send_email_confirmation
			respond_to do |format|
				format.html { redirect_to current_user, :notice => "Your new email address has been added" }
				format.js { } #fall through to create.js.erb
			end
		else
			logger.info("Errors: #{@user_email.errors.messages}")
			respond_to do |format|
				format.html { render 'new' }
				format.js { 
					flash.now[:error] = error_display(@user_email)
					render 'error_display'
				}
			end
		end

	end

	def error_display(user_email)
		unless user_email.errors.blank?
			error_list = user_email.errors.messages.collect {|k,v| "#{k} #{v.join(',')}" }
			return error_list.join("\n")
		end
	end

	def set_primary_email
		@user_email = UserEmail.find_by_id(params[:id])
		@user_email.set_primary_override if @user_email
		get_email_addresses
		respond_to do |format|
			format.html { redirect_to current_user, :notice => 'Your primary email has been updated'}
			format.js { } #fall through
		end
	end

	def destroy
		@user_email = UserEmail.find(params[:id])
		unless @user_email.is_primary?
			@user_email.destroy
			respond_to do |format|
				format.html { redirect_to current_user }
				format.js {}
			end
		else
			flash.now[:error] = "You cannot delete your primary email address. 
											 Please assign a new primary email address before deleting this address"
			respond_to do |format|
				format.html {redirect_to current_user}
				format.js {render 'error_display'}
			end
		end
	end

  private
    def authenticate
      deny_access unless signed_in?
    end

    def get_email_addresses
    	@user_emails = current_user.email_addresses
    end
end
