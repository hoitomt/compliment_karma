class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ShellHelper
  include ViewStateHelper
  include ComplimentsHelper
  
  before_filter :shell_authenticate
  before_filter :current_view
  
  def shell_authenticate
    if Rails.env.development?
      logger.info("Founder Signed In: #{founder_signed_in?}")
      deny_shell_access unless founder_signed_in?
    end
  end

  # This is used for setting UI effects based on the current page - user menu
  def current_view
  	@current_controller = params[:controller]
    @current_action = params[:action]
    logger.info("Current Controller|Action: #{@current_controller}|#{@current_view}")
  end
  
end
