class InvitationsController < ApplicationController
  # before_filter :authenticate
  
  def new
    @invitation = Invitation.new
  end
  
  def create
    logger.info("Send Invitation")
    user = current_user || User.find_user_by_email(params[:invitation][:invite_email])
    if params[:multi_invitation]
      send_multiple_invitations(params[:multi_invitation])
    else
      if user
        logger.info("Current User")
        flash[:notice] = "Welcome back to ComplimentKarma #{user.first_last}. Please log in"
        redirect_to current_user || login_path
      else
        logger.info("Not Current User")
        email = params[:invitation][:invite_email]
        if Domain.email_on_whitelist?(email)
          flash[:notice] = "Congrats! You are already eligible to signup. " + 
                           "Please fill the form below to create your free account."
          flash[:email] = email
          redirect_to new_user_path
        elsif @invitation = Invitation.create_invitation(params[:invitation][:invite_email])
          flash[:notice] = "Thanks a lot for your interest. We 
          have added you to our priority invite list. Once we have 
          more invitations available, we will gladly email you one."
          redirect_to root_path
        else
          flash[:notice] = "There was an error when sending your invitation"
          redirect_to root_path
        end
      end
      
    end
  end
  
  def send_multiple_invitations(invitations)
    invitations.each do |k, v|
      logger.info ("Invite Email: #{v}")
      if v && v.length > 1
        v = "#{v}@#{current_user.domain}" unless v.include? "@"
        Invitation.create_invitation(v, current_user.email)
      end
    end
    next_page = params[:next_page]
    if next_page =~ /invite_coworkers/
      redirect_to invite_others_path
    elsif current_user
      redirect_to current_user
    else
      redirect_to root_path
    end
  end
  
  private
    def authenticate
      deny_access unless signed_in?
    end
  
end
