class MailerController < ApplicationController
	before_filter :is_founder_signed_in?

	def send_compliment
		@compliment = Compliment.last
    @skill= Skill.find_by_id(@compliment.skill_id)
    @sender = @compliment.sender
    @receiver = @compliment.receiver
    @first_compliment = Compliment.first_compliment?(@sender, @receiver)
    @relationship = Relationship.get_relationship(@sender, @receiver)
    @existing_contact = @receiver.existing_contact?(@sender)
    @timestamp = DateUtil.date_time_format(@compliment.created_at)
		render :file => 'compliment_mailer/send_compliment.html.erb', :layout => 'compliment_mailer'
	end

	def receiver_confirmation_reminder
		@compliment = Compliment.last
		@sender = @compliment.sender
    @receiver = User.find_user_by_email(@compliment.receiver_email)
    @receiver.generate_token(:new_account_confirmation_token) if @receiver
    @skill= Skill.find_by_id(@compliment.skill_id)
    @timestamp = DateUtil.get_time_gap(@compliment.created_at)
		render :file => 'compliment_mailer/receiver_confirmation_reminder.html.erb', :layout => 'compliment_mailer'
	end

	def receiver_registration_invitation
		@compliment = Compliment.last
		@sender = @compliment.sender
    @skill= Skill.find_by_id(@compliment.skill_id)
    @timestamp = DateUtil.get_time_gap(@compliment.created_at)
		render :file => 'compliment_mailer/receiver_registration_invitation.html.erb', :layout => 'compliment_mailer'
	end

	def notify_ck_unrecognized_sender
		@params = Hash.new("")
    @params['Date'] = DateTime.now
		render :file => 'compliment_mailer/notify_ck_unrecognized_sender.html.erb', :layout => 'compliment_mailer'
	end

	def notify_sender_unconfirmed_sender
    # @params = params
    @user = User.last
		render :file => 'compliment_mailer/notify_sender_unconfirmed_sender.html.erb', :layout => 'compliment_mailer'
	end

	def notify_sender_unknown_skill
    # @params = params
    @user = User.last
    @compliment = Compliment.last
		render :file => 'compliment_mailer/notify_sender_unknown_skill.html.erb', :layout => 'compliment_mailer'
	end

  def notify_sender_unrecognized_sender
    # @params = params
		render :file => 'compliment_mailer/notify_sender_unrecognized_sender.html.erb', :layout => 'compliment_mailer'
  end

  def account_confirmation
		@user = User.last
		render :file => 'user_mailer/account_confirmation.html.erb', :layout => 'user_mailer'
  end

	def new_email_confirmation
		@user_email = UserEmail.last
    @user_email.generate_token(:new_email_confirmation_token) if @user_email
		# @user = @user_email.user
		@user = User.last
		render :file => 'user_mailer/new_email_confirmation.html.erb', :layout => 'user_mailer'
	end

	def password_reset
		@user = User.last
    @user.generate_token(:password_reset_token) if @user
		render :file => 'user_mailer/password_reset.html.erb', :layout => 'user_mailer'
	end

	private
		def is_founder_signed_in?
			deny_access unless founder_signed_in?
		end
end