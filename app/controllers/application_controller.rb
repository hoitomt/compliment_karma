class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ShellHelper
  include ViewStateHelper
  include ComplimentsHelper
  include RecognitionHelper
  
  before_filter :shell_authenticate
  before_filter :current_view
  before_filter :set_meta
  
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

  def set_meta
    logger.info("Request URL: #{request.url}")
    description = "Send / Receive Compliments from your Professional / Social Network. 
                   Build Proof of Experience and Earn your Employer sponsored Rewards"
    @og_meta_url = request.url
    @og_meta_title = description
    @og_meta_description = fb_og_meta_description
    @meta_description = description
    @og_meta_image = og_meta_image
  end
  
end
