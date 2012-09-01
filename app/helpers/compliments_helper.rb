module ComplimentsHelper

  def set_compliment_panel
    @compliment = Compliment.new(params[:compliment])
    @compliment.sender_email = current_user.email
    @sender_is_a_company = sender_is_a_company?
    @receiver_is_a_company = false
    set_this_week_compliments
    if !current_user?(@user) #&& current_user.is_company_administrator?(@user.company.id)
      @compliment.receiver_display = @user.search_result_display
      @compliment.receiver_user_id = @user.id
      @receiver_is_a_company = @user.is_a_company?
    end
    # @skills = Skill.list_for_autocomplete
    @compliment_types = ComplimentType.compliment_type_list(@sender_is_a_company, @receiver_is_a_company)
    if flash[:compliment]
      @compliment = Compliment.new(flash[:compliment].attributes)
      flash[:compliment].errors.each do |attr, msg|
        @compliment.errors.add(attr, msg)
      end
      @compliment.errors.full_messages.each do |msg|
        logger.info("Error: #{msg}")
      end
    end
    logger.info("Compliment Types: #{@compliment_types}")
    flash.delete(:compliment)
  end

  def sender_is_a_company?
    return true if current_user.is_a_company?
    return false
  end

  def set_this_week_compliments
    @compliments_since_last_monday = Compliment.get_compliments_since_monday(@user)
  end
  

end
