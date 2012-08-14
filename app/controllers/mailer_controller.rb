class MailerController < ApplicationController
	layout 'compliment_mailer'
	before_filter :is_founder_signed_in?

	def send_compliment
		@compliment = Compliment.find(1264)
		@sender = @compliment.sender
		@receiver = @compliment.receiver
		@relationship = Relationship.get_relationship(@sender, @receiver)
		@confirmed_relationship = @relationship.accepted?
    @skill= Skill.find_by_id(@compliment.skill_id)
    @timestamp = DateUtil.get_time_gap(@compliment.created_at)
		render :file => 'compliment_mailer/send_compliment.html.erb'
	end

	def receiver_confirmation_reminder
		@compliment = Compliment.last
		@sender = @compliment.sender
    @receiver = User.find_by_email(@compliment.receiver_email)
    @receiver.generate_token(:new_account_confirmation_token) if @receiver
    @skill= Skill.find_by_id(@compliment.skill_id)
    @timestamp = DateUtil.get_time_gap(@compliment.created_at)
		render :file => 'compliment_mailer/receiver_confirmation_reminder.html.erb'
	end

	def receiver_registration_invitation
		@compliment = Compliment.last
		@sender = @compliment.sender
    @skill= Skill.find_by_id(@compliment.skill_id)
    @timestamp = DateUtil.get_time_gap(@compliment.created_at)
		render :file => 'compliment_mailer/receiver_registration_invitation.html.erb'
	end

	def notify_ck_unrecognized_sender
		@params = Hash.new("")
    @params['Date'] = DateTime.now
		render :file => 'compliment_mailer/notify_ck_unrecognized_sender.html.erb'
	end

	def notify_sender_unconfirmed_sender
    # @params = params
    @user = User.last
		render :file => 'compliment_mailer/notify_sender_unconfirmed_sender.html.erb'
	end

	def notify_sender_unknown_skill
    # @params = params
    @user = User.last
    @compliment = Compliment.last
		render :file => 'compliment_mailer/notify_sender_unknown_skill.html.erb'
	end

  def notify_sender_unrecognized_sender
    # @params = params
		render :file => 'compliment_mailer/notify_sender_unrecognized_sender.html.erb'
  end

	private
		def is_founder_signed_in?
			deny_access unless founder_signed_in?
		end
end