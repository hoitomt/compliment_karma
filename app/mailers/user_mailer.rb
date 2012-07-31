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
end
