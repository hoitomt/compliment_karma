class PasswordResetsController < ApplicationController
  def new
    @title = "Password Reset"
  end
  
  def create
    user = User.find_user_by_email(params[:email])
    note = nil
    if user
      logger.info("Found User")
      user.send_password_reset
      note = "An email has been sent with password reset instructions"
      redirect_to login_path, :notice => note
    elsif Invitation.find_by_invite_email(params[:email])
      note = "We love it that you are impatient to use ComplimentKarma. 
              However you cannot reset your password at this time. We will
              let you know once the site is ready to go."
      redirect_to login_path, :notice => note
    else
      flash.now[:error] = "Oh Snap! We couldn't find you using the 
                           information you entered. Please try again."
      render :new
    end
  end
  
  def edit
    @title = "Password Reset"
    @user = User.find_by_password_reset_token(params[:id])
    if @user.nil?
      flash[:error] = "Your password reset has expired"
      redirect_to login_path
    end
  end
  
  def update
    @user = User.find_by_password_reset_token(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired"
    else
      @user.password = params[:user][:password]
      @user.encrypt_password
      if @user.save
        redirect_to login_path, :notice => "Password has been reset, Please log in"
      else
        render :edit
      end
    end
  end

end
