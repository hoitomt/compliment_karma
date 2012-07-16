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
    @compliment = Compliment.new
    @compliment.comment = params[:compliment][:comment]
    @compliment.compliment_type_id = params[:compliment][:compliment_type_id]
    skill = Skill.find_or_create_skill(params[:skill_id_result], params[:compliment][:skill_id])
    @compliment.skill_id = skill.id
    set_sender
    set_receiver
    if @compliment.save
      respond_to do |format|
        format.html{
          set_success_notice
          process_redirect("success")
        }
      end
    else
      respond_to do |format|
        format.html {
          error_msg = ""
          @compliment.errors.messages.each do |k,v|
            v.each do |error_str|
              error_msg += "#{error_str}<br />"
            end
          end
          flash[:error] = "Your compliment could not be sent<br />#{error_msg}".html_safe
          process_redirect("failure")
        }
      end
    end
  end
  
  # if an email address was entered in the input field and it is valid, use it
  # Otherwise use the input id that was selected via the drop down
  def set_receiver
    receiver_id = params[:compliment_receiver_id]
    receiver_display = params[:compliment][:receiver_display]
    input_user = User.find_by_email(receiver_display) if User.valid_email?(receiver_display)
    if !input_user.blank?
      @compliment.receiver_email = params[:compliment][:receiver_display]
    elsif !receiver_id.blank?
      @compliment.receiver_user_id = receiver_id
      @compliment.receiver_email = User.find(receiver_id).email
    else
      # invalid email address
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
  
  def process_redirect(result)
    # Don't send the compliment back to the screen
    flash[:compliment] = @compliment if result == "failure"
    user = User.find_by_email(@compliment.sender_email)
    
    if params[:request_page] =~ /user/
      redirect_to user
    elsif params[:request_page] =~ /main/
      if result == "failure"
        redirect_to root_path
      elsif user.blank?
        redirect_to signup_path
        flash[:new_user] = true
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
  
  def set_success_notice
    if @compliment.compliment_status == ComplimentStatus.ACTIVE
      flash[:notice] = "Your compliment has been sent"
    elsif @compliment.compliment_status == ComplimentStatus.PENDING_RECEIVER_CONFIRMATION ||
          @compliment.compliment_status == ComplimentStatus.PENDING_RECEIVER_REGISTRATION
      flash[:notice] = "Your compliment has been saved"
    end
  end

end
