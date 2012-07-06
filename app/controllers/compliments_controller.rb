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
    logger.info("Request " + request.fullpath)
    @compliment = Compliment.new(params[:compliment])
    skill = Skill.find_or_create(params[:compliment][:skill_id])
    @compliment.skill_id = skill.id if skill
    logger.info("Skill: #{skill}")
    logger.info("Compliment Skill: #{@compliment.skill_id}")
    @compliment.sender_email = sender_email(params)
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
          flash[:error] = "Your compliment could not be sent #{@compliment.errors.messages.to_s}"
          process_redirect("failure")
        }
      end
    end
  end
  
  def sender_email(params)
    if params[:compliment][:sender_email]
      return params[:compliment][:sender_email]
    elsif current_user
      return current_user.email
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
