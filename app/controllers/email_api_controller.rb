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
  
  def compliment_new
    logger.info(params.inspect)
    render :nothing => true
  end



  # def on_incoming_message
  #    if request.method == 'POST':
  #        sender    = request.POST.get('sender')
  #        recipient = request.POST.get('recipient')
  #        subject   = request.POST.get('subject', '')

  #        body_plain = request.POST.get('body-plain', '')
  #        body_without_quotes = request.POST.get('stripped-text', '')
  #        # note: other MIME headers are also posted here...

  #        # attachments:
  #        for key in request.FILES:
  #            file = request.FILES[key]
  #            # do something with the file
  #          end

  #        # Returned text is ignored but HTTP status code matters:
  #        # Mailgun wants to see 2xx, otherwise it will make another attempt in 5 minutes
  #        return HttpResponse('OK')
  #      end
  
end
