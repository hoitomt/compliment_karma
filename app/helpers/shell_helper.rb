module ShellHelper
  
  def sign_into_shell(founder)
    cookies.permanent.signed[:remember_f_token] = [founder.id, founder.salt]
    self.current_founder = founder
  end
  
  def current_founder=(founder)
    @current_founder = founder
  end
  
  def current_founder
    @current_founder ||= founder_from_remember_f_token
  end
  
  def founder_signed_in?
    !current_founder.nil?
  end
  
  def shell_sign_out
    cookies.delete(:remember_f_token)
    self.current_founder = nil
  end
  
  def current_founder?(founder)
    founder == current_founder
  end
  
  def deny_shell_access
    redirect_to new_shell_path
  end
  
  private
    def founder_from_remember_f_token
      User.authenticate_founder_with_salt(*remember_f_token)
    end
    
    def remember_f_token
      cookies.signed[:remember_f_token] || [nil, nil]
    end
end