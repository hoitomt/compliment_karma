class UserMailer < ActionMailer::Base
  default :from => 'no-reply@complimentkarma.com'

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
  
  def account_confirmation(user)
    @user = user
    mail :to => user.email, :subject => "Welcome to Compliment Karma! Please confirm your email"
  end

  def new_email_confirmation(user_email)
  	return if user_email.nil?
    @user_email = user_email
  	@user = user_email.user
  	mail :to => user_email.email, :subject => "Please confirm your new email address"
  end
end
