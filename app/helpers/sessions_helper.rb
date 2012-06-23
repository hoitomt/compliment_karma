module SessionsHelper
  
  def sign_in(user, remember_me)
    if remember_me
      logger.info("Permanent Token")
      cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    else
      logger.info("Temporary Token")
      cookies.signed[:remember_token] = { :value => [user.id, user.salt], :expires => 6.hours.from_now.utc }
    end
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end

  def customer_admin_user?
    current_user.is_customer_admin?
  end

  def site_admin_user?
    current_user.is_site_admin?
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def deny_access
    logger.info("Deny Access")
    flash[:error] = "Please log in to complete the desired action"
    redirect_to login_path
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end

  private
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    def clear_return_to
      session.delete(:return_to)
    end
end
