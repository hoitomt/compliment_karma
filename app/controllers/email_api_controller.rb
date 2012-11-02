class EmailApiController < ApplicationController
  skip_before_filter :shell_authenticate

  def new_account_confirmation
    @title = "Account Confirmation"
    @user = User.find_by_new_account_confirmation_token(params[:confirm_id])
    if current_user?(@user)
      current_user.confirm_account
      Compliment.user_confirmation(current_user)
      flash[:notice] = "Welcome #{current_user.first_last}. 
                        Thanks for signing up.<br />Please log in and Happy Complimenting".html_safe
      sign_out
      redirect_to login_path
    else
      if @user
        Compliment.user_confirmation(@user)
        @user.confirm_account
        flash[:notice] = "Welcome #{@user.first_last}. 
                        Thanks for signing up.<br />Please log in and Happy Complimenting".html_safe
        sign_out
        redirect_to login_path
      else
        flash[:notice] = "The confirmation link that you clicked was not recognized. 
                          Please click the link from the latest confirmation email or 
                          resend your confirmation email. Thanks"
        redirect_to root_path
      end
    end
  end

  def new_email_confirmation
    @user_email = UserEmail.find_by_new_email_confirmation_token(params[:confirm_id])
    @user = @user_email.try(:user)
    if @user_email && current_user?(@user)
      logger.info("Email Confirmation: User is logged in")
      logger.info("User Email ID: #{@user_email.id}")
      @user_email.confirm_email
      flash[:notice] = "Thanks! Email address #{@user_email.email} has been confirmed. 
                        You can now log in and receive compliments using this email address"
      redirect_to current_user
    else
      logger.info("Email Confirmation: User is NOT logged in")
      if @user
        flash[:notice] = "Thanks! Email address #{@user_email.email} has been confirmed. 
                          You can now log in and receive compliments using this email address"
        @user_email.confirm_email
        redirect_to root_path
      else
        redirect_to root_path
      end
    end
  end
  
  def invitation_acceptance
    
  end
  
  def accept_compliment
    action_item = ActionItem.find_by_id(params[:id])
    if action_item.blank?
      redirect_to root_path
    elsif action_item.complete?
      flash['notice'] = "You have already taken action on this item"
      redirect_to root_path
    else
      compliment = Compliment.find_by_id(action_item.recognition_id)
      group = compliment.get_receiver_group_from_compliment_type
      redirect_to accept_action_item_path(:user_id => action_item.user_id,
                                          :id => action_item.id,
                                          :originator_user_id => action_item.originating_user_id,
                                          :groups => {group.id.to_s => 'yes'})
    end
  end

  def decline_compliment
    action_item = ActionItem.find_by_id(params[:id])
    if action_item.complete?
      flash['notice'] = "You have already taken action on this item"
      redirect_to root_path
    else
      redirect_to decline_action_item_path(:user_id => action_item.user_id,
                                          :id => action_item.id,
                                          :originator_user_id => action_item.originating_user_id)
    end
  end

  def compliment_new
    logger.info("Recipient: #{params['recipient']}")
    logger.info("To: #{params['To']}")
    logger.info("From: #{params['from']}")
    logger.info("Subject: #{params['subject']}")
    logger.info("Body Plain: #{params['body-plain']}")
    logger.info("Body Stripped: #{params['stripped-text']}")
    to_param = params['To']
    receiver_array = to_param.blank? ? [] : to_param.split(',')
    receiver_array.each do |receiver|
      receiver.strip!
      # Don't create compliments to our email forwarders (Mailgun)
      if !Domain.email_from_forwarder?(receiver)
        compliment = Compliment.new
        created = compliment.create_from_api(receiver, params)
        if created
          logger.info("Created compliment from incoming email\n" +
                    "receiver: #{compliment.receiver_email}\n" +
                    "sender: #{compliment.sender_email}\n" +
                    "skill: #{compliment.skill_id}"
                    )
        end
      end
    end
    render :nothing => true
  end

  # Email information
  # Parameters: {
  #   "recipient"=>"new@app5024011.mailgun.org", 
  #   "sender"=>"mike.hoitomt@gmail.com", 
  #   "subject"=>"Test", 
  #   "from"=>"Michael Hoitomt <mike@hoitomt.com>", 
  #   "Received"=>"by 10.64.99.34 with HTTP; Sat, 28 Jul 2012 20:43:32 -0700 (PDT)", 
  #   "X-Envelope-From"=>"<mike.hoitomt@gmail.com>", 
  #   "Dkim-Signature"=>"v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113; h=mime-version:sender:date:x-google-sender-auth:message-id:subject :from:to:content-type; bh=E17oRAfZIrqcdr3264V+hJai8K5oceq+iTzDJqgmJts=; b=ztgXPY4B7qt5CmC3BWJ7db2EVrMCgg+u/6mv8/9i312HCAbguIDYHcARkz/VvjQCGM ErxjmnDDYeCXgAaEDVVtT8Gtm2EuzbVDwsKrNff0fJ9oSVUQ3SuWipvS02bDun8LofVN O6x+l+t7ZVTYGZa6T8tIlRqpEmyERVzlWrLjQ8+mZcGQ18H4+MMeWI6A/feqJ1N5NIPx n8KPcL6GqIBlzj/qXH8vuuvPJ2IEQKcOG5c42fArvRPZjdRqmLI5fF6NTFZU++B5HUlh AGx17DawIw+zg3/HZttBZIOqUqPI4ofMp6xOZ2GN/a49M7TWyrAKUUiid7DNe0QC18BP 497g==", 
  #   "Mime-Version"=>"1.0", 
  #   "Sender"=>"mike.hoitomt@gmail.com", 
  #   "Date"=>"Sat, 28 Jul 2012 22:43:32 -0500", 
  #   "X-Google-Sender-Auth"=>"7mX5ixy79iqMV6xHsTMu7h6DNbY", 
  #   "Message-Id"=>"<CAAnL2r1i6DgxA=8BTxZBTLaj-fjna3+oOxpn29pWpDhJw4EWOA@mail.gmail.com>", 
  #   "Subject"=>"Test", 
  #   "From"=>"Michael Hoitomt <mike@hoitomt.com>", 
  #   "To"=>"new@app5024011.mailgun.org", 
  #   "Content-Type"=>"multipart/alternative; boundary=\"e89a8f2354d7d27f4104c5efbfd0\"", 
  #   "message-headers"=>"[
  #     [\"Received\", \"by luna.mailgun.net with SMTP mgrt 4410821; Sun, 29 Jul 2012 03:43:34 +0000\"], 
  #     [\"X-Envelope-From\", \"<mike.hoitomt@gmail.com>\"], 
  #     [\"Received\", \"from mail-ob0-f176.google.com (mail-ob0-f176.google.com [209.85.214.176]) by mxa.mailgun.org with ESMTP id 5014b165.5ac65f0-luna4; Sun, 29 Jul 2012 03:43:33 -0000 (UTC)\"], 
  #     [\"Received\", \"by obbtb18 with SMTP id tb18so8815646obb.35 for <new@app5024011.mailgun.org>; Sat, 28 Jul 2012 20:43:33 -0700 (PDT)\"], [\"Dkim-Signature\", \"v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113; h=mime-version:sender:date:x-google-sender-auth:message-id:subject :from:to:content-type; bh=E17oRAfZIrqcdr3264V+hJai8K5oceq+iTzDJqgmJts=; b=ztgXPY4B7qt5CmC3BWJ7db2EVrMCgg+u6mv8/9i312HCAbguIDYHcARkz/VvjQCGM ErxjmnDDYeCXgAaEDVVtT8Gtm2EuzbVDwsKrNff0fJ9oSVUQ3SuWipvS02bDun8LofVN O6x+l+t7ZVTYGZa6T8tIlRqpEmyERVzlWrLjQ8+mZcGQ18H4+MMeWI6A/feqJ1N5NIPx n8KPcL6GqIBlzj/qXH8vuuvPJ2IEQKcOG5c42fArvRPZjdRqmLI5fF6NTFZU++B5HUlh AGx17DawIw+zg3/HZttBZIOqUqPI4ofMp6xOZ2GN/a49M7TWyrAKUUiid7DNe0QC18BP 497g==\"], 
  #     [\"Mime-Version\", \"1.0\"], 
  #     [\"Received\", \"by 10.50.149.200 with SMTP id uc8mr5572356igb.27.1343533412941; Sat, 28 Jul 2012 20:43:32 -0700 (PDT)\"], 
  #     [\"Sender\", \"mike.hoitomt@gmail.com\"], [\"Received\", \"by 10.64.99.34 with HTTP; Sat, 28 Jul 2012 20:43:32 -0700 (PDT)\"], 
  #     [\"Date\", \"Sat, 28 Jul 2012 22:43:32 -0500\"], 
  #     [\"X-Google-Sender-Auth\", \"7mX5ixy79iqMV6xHsTMu7h6DNbY\"], 
  #     [\"Message-Id\", \"<CAAnL2r1i6DgxA=8BTxZBTLaj-fjna3+oOxpn29pWpDhJw4EWOA@mail.gmail.com>\"], 
  #     [\"Subject\", \"Test\"], [\"From\", \"Michael Hoitomt <mike@hoitomt.com>\"], 
  #     [\"To\", \"new@app5024011.mailgun.org\"], 
  #     [\"Content-Type\", \"multipart/alternative; boundary=\\\"e89a8f2354d7d27f4104c5efbfd0\\\"\"]
  #     ]", 
  #     "timestamp"=>"1343533414", 
  #     "token"=>"8dn-2yzubdc4bzon259xy1pdrncrjv25rlktcvmvqzbrs0-8b4", 
  #     "signature"=>"e7a20fe80f3d604f39faed6cdd2e9e53875740b6d800f6abcfcd1edaa92abba1", 
  #     "body-plain"=>"This is a test message\r\n", 
  #     "body-html"=>"This is a test message\r\n", 
  #     "stripped-html"=>"This is a test message\r\n",
  #     "stripped-text"=>"This is a test message", "stripped-signature"=>""
  #   }
  
end
