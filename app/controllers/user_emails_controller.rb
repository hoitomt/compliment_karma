class UserEmailsController < ApplicationController
	before_filter :authenticate

	def index
		@user_emails = current_user.email_addresses
		@user_email = UserEmail.new	
	end

	def new
		@user_email = UserEmail.new
	end

	def create
		@user_email = UserEmail.new(params[:user_email])
		@user_email.user_id = current_user.id
		if @user_email.save
			respond_to do |format|
				format.html { redirect_to current_user, :notice => "Your new email address has been added" }
				format.js { } #fall through to create.js.erb
			end
		else
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
		@user_email = UserEmail.find_by_id(params[:user_email_id])
		@user_email.set_primary_override if @user_email
		respond_to do |format|
			format.html { redirect_to current_user, :notice => 'Your primary email has been updated'}
			format.js { } #fall through
		end
	end

  private
    def authenticate
      deny_access unless signed_in?
    end
end
