class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ShellHelper
  include ViewStateHelper
  
  before_filter :shell_authenticate
  before_filter :current_view
  
  def shell_authenticate
    logger.info("Founder Signed In: #{founder_signed_in?}")
    deny_shell_access unless founder_signed_in?
  end

  # This is used for setting UI effects based on the current page - user menu
  def current_view
  	@current_controller = params[:controller]
    @current_action = params[:action]
    logger.info("Current Controller|Action: #{@current_controller}|#{@current_view}")
  end
  
end
