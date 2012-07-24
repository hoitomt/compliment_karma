class ComplimentsController < ApplicationController
  
  def index
    @compliments = Compliment.all
  end

  def new
    @compliment = Compliment.new
    @recipient = User.find_by_id(params[:recipient_id])
    @recipient_email = @recipient.email if @recipient
  end

  def create    
    referrer = request.referrer
    @compliment = Compliment.new
    @compliment.comment = params[:compliment][:comment]
    @compliment.compliment_type_id = params[:compliment][:compliment_type_id]
    skill = Skill.find_or_create_skill(params[:skill_id_result], params[:compliment][:skill_id])
    @compliment.skill_id = skill.id
    set_sender
    set_receiver
    logger.info(@compliment.inspect)
    if @compliment.save
      logger.info("compliment saved")
      set_success_notice
      process_redirect("success", referrer)
    else
      logger.info("compliment NOT saved")
      logger.info(@compliment.errors.messages)
      respond_to do |format|
        format.html {
          error_msg = ""
          @compliment.errors.messages.each do |k,v|
            v.each do |error_str|
              error_msg += "#{error_str}<br />"
            end
          end
          if request.format.js?
            flash.now[:error] = "Your compliment could not be sent. #{error_msg}".html_safe
          else
            flash[:error] = "Your compliment could not be sent. #{error_msg}".html_safe
          end
          process_redirect("failure", referrer)
        }
      end
    end
  end
    
  def process_redirect(result, referrer)
    logger.info("Redirect")
    # Don't send the compliment back to the screen
    flash[:compliment] = @compliment if result == "failure"
    user = User.find_by_email(@compliment.sender_email)
    respond_to do |format|
      format.html {redirect_to referrer}
      format.js { 
        logger.info("Javascript Render")
        render :create_compliment 
      }
      # format.js { render :nothing => true }
    end
  end
  
  # if an email address was entered in the input field and it is valid, use it
  # Otherwise use the input id that was selected via the drop down
  def set_receiver
    receiver_id = params[:compliment_receiver_id]
    receiver_display = params[:compliment][:receiver_display]
    input_user = User.find_by_email(receiver_display) if User.valid_email?(receiver_display)
    if !receiver_id.blank?
      @compliment.receiver_user_id = receiver_id
      @compliment.receiver_email = User.find(receiver_id).email
    elsif !input_user.blank?
      @compliment.receiver_user_id = input_user.id
      @compliment.receiver_email = input_user.email
    else
      @compliment.receiver_email = params[:compliment][:receiver_display]
    end
  end

  def set_sender
    if params[:compliment][:sender_email]
      @compliment.sender_email = params[:compliment][:sender_email]
    elsif current_user
      @compliment.sender_email = current_user.email
    else
      return nil
    end
  end
  
  def set_success_notice
    if @compliment.compliment_status == ComplimentStatus.ACTIVE
      msg = "Your compliment has been sent"
    elsif @compliment.compliment_status == ComplimentStatus.PENDING_RECEIVER_CONFIRMATION ||
          @compliment.compliment_status == ComplimentStatus.PENDING_RECEIVER_REGISTRATION
      msg = "Your compliment has been saved"
    end
    if request.format.js?
      flash.now[:notice] = msg
    else
      flash[:notice] = msg
    end
  end

  def set_compliment_types
    sender_is_a_company = params[:sender_is_a_company]
    receiver_is_a_company = params[:receiver_is_a_company]
    @compliment_types = ComplimentType.compliment_type_list(sender_is_a_company, receiver_is_a_company)
    logger.info(@compliment_types)
  end

end
