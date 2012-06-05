class EmailApiController < ApplicationController
  
  def new_account_confirmation
    @title = "Account Confirmation"
    if current_user
      logger.info("User is logged in")
      current_user.account_status = AccountStatus.CONFIRMED
      current_user.save
    else
      logger.info("User is not logged in")
      @user = User.find_by_new_account_confirmation_token(params[:confirm_id])      
      if @user
        @user.account_status = AccountStatus.CONFIRMED
        @user.save
      else
        redirect_to root_path
      end
    end
  end
  
  def invitation_acceptance
    
  end
  
  def compliment_new_user

  end
  
end
