class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create, :new_account_confirmation]
  before_filter :correct_user, :except => [:new, :create, :new_account_confirmation, 
                                           :show, :get_more_karma_live_records,
                                           :professional_profile, :social_profile, 
                                           :achievements, :contacts, :employees, 
                                           :rewards, :settings, :my_updates, :switch_accounts ]
  before_filter :get_confirmation_status, :except => [:new, :create, :switch_accounts]
  before_filter :hide_unconfirmed_user
  before_filter :set_static_vars
  before_filter :set_compliment_panel, 
                :only => [:show, :my_updates, :my_updates_all, :professional_profile,
                          :social_profile, :received_compliments, :sent_compliments,
                          :achievements, :contacts, :settings, :employees ]
    
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_account_confirmation
      sign_in(@user, false)
      redirect_to invite_coworkers_path
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
    logger.info("User Name: " + @user.full_name)
    set_title
    set_karma_live_panel
    set_pending_items
    # my_updates
    set_update_history_read
    logger.info("Confirmation status - Unconfirmed?: #{@unconfirmed}")
    menu_response_handler
  end

  def edit_from_profile
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.name = params[:user][:name]
    @user.set_name
    @user.update_attributes(params[:user])
    redirect_to @user
  end

  def my_updates
    user = my_updates_user
    @my_update_items = UpdateHistory.get_recent_update_history(user)
    user.update_attributes(:last_read_notification_date => DateTime.now)
    respond_to do |format|
      format.html {}
      format.js {
        @popup_box = true
      }
    end
  end

  def my_updates_all
    @my_update_items = UpdateHistory.find_all_by_user_id(my_updates_user.id)
    render 'my_updates'
  end

  def menu_response_handler
    respond_to do |format| 
      format.html { }
      format.js { render 'menu' }
    end
  end

  def professional_profile
    @user = User.find_by_id(params[:id])
    @user_is_a_company = @user.is_a_company?
    @professional_experiences = @user.experiences
    @current_experience = @user.experiences.first
    sent_compliments = Compliment.sent_professional_compliments(@user)
    received_compliments = Compliment.received_professional_compliments(@user)
    @compliments_sent = sent_compliments.count
    @compliments_received = received_compliments.count
    @rewards_earned_amount = Reward.earned_reward_amount(@user)
    @rewards_earned_count = @user.rewards_received.count
    @rewards_sent = @user.rewards_presented.count
    @followers = Follow.followers(@user.id)
    @following = Follow.following(@user.id)
    @compliments_received_by_skill = compliment_count_by_skill(received_compliments)
    menu_response_handler
  end

  def social_profile
    @user = User.find_by_id(params[:id])
    sent_compliments = Compliment.sent_social_compliments(@user)
    received_compliments = Compliment.received_social_compliments(@user)
    @compliments_sent = sent_compliments.count
    @compliments_received = received_compliments.count
    @followers = Follow.followers(@user.id)
    @following = Follow.following(@user.id)
    @compliments_received_by_skill = compliment_count_by_skill(received_compliments)
    menu_response_handler
  end

  def received_compliments
    menu_response_handler
  end

  def sent_compliments
    menu_response_handler
  end

  def achievements
    menu_response_handler
  end

  def contacts
    menu_response_handler
  end

  def settings
    @company = @user.company
    @departments = @company.departments if @company
    menu_response_handler
  end

  def employees
    @company = @user.company
    @results = @company.employees
    menu_response_handler
  end

  def rewards
    @company = @user.company
    @departments = @company.departments
    @managers = []
    @activity_types = ActivityType.list
    activity_type_id = set_reward_activity_type
    @user_types = []
    employees = set_employees
    @employees = Reward.build_employee_vo(employees, activity_type_id)
    # build_employee_vo(employees, activity_type_id)
    logger.info("Activity Type #{@activity_type}")
  end

  def set_reward_activity_type
    activity_type_id_filter = params[:filter][:activity_type_id] if params[:filter]
    activity_type_id = activity_type_id_filter || ActivityType.compliments_received.id
    logger.info("Activity Type ID: #{activity_type_id}")
    @activity_type = ActivityType.find(activity_type_id)
    # logger.info("Activity Type #{@activity_type}")
    return @activity_type.blank? ? activity_type_id : @activity_type.id
  end

  def set_employees
    unless params[:filter]
      employees = @company.users
      return employees
    end
    number_of_employees = params[:filter][:number_of_employees]
    department = CompanyDepartment.find_by_id(params[:filter][:department_id])
    activity_type = ActivityType.find(params[:filter][:activity_type_id])
    @start_date = params[:filter][:as_of_date]
    @stop_date = params[:filter][:stop_date]
    if !department.blank? && !number_of_employees.blank?
      return department.users.limit(number_of_employees.to_i)
    elsif !department.blank? && number_of_employees.blank?
      return department.users
    elsif department.blank? && !number_of_employees.blank?
      return @company.users.limit(number_of_employees.to_i)
    else
      return @company.users
    end
  end

  def build_employee_vo(employees, activity_type_id)
    @employees = []
    employees.each do |user|
      e = {}
      e[:id] = user.id
      e[:full_name] = user.first_last
      e[:manager] = ''
      e[:user_type] = ''
      e[:department] = user.company_departments.first
      case activity_type_id
        when ActivityType.compliments_received.id
          e[:activity_type] = Compliment.sent_professional_compliments(user).count
        when ActivityType.compliments_sent.id
          e[:activity_type] = Compliment.received_professional_compliments(user).count
        when ActivityType.trophies_earned.id
        when ActivityType.badges_earned.id
        else
      end
      @employees << e
    end
  end

  def upload_photo
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    redirect_to @user
  end

  def sender_is_a_company?
    return true if current_user.is_a_company?
    return false
  end
  
  def set_karma_live_panel
    @all_karma_live_items = get_karma_live_items(params[:feed_item_type], params[:relation_type])
    @recognition_type_compliment = RecognitionType.COMPLIMENT
    @recognition_type_reward = RecognitionType.REWARD
    @recognition_type_accomplishment = RecognitionType.ACCOMPLISHMENT
    @karma_live_items_count = @all_karma_live_items.count
    @current_count = @page * @per_page
    @current_count = @karma_live_items_count if @current_count > @karma_live_items_count
    @karma_live_items = Paging.page(@all_karma_live_items, @page, @per_page)
    logger.info("Karma Live Item Count: #{@karma_live_items_count}")
  end

  def accept_relationship
    sender = User.find_by_id(params[:sender_id])
    relationship = Relationship.get_relationship(sender, current_user)
    relationship.accept_relationship
    redirect_to current_user
  end
  
  def decline_relationship
    sender = User.find_by_id(params[:sender_id])
    relationship = Relationship.get_relationship(sender, current_user)
    relationship.decline_relationship
    redirect_to current_user  
  end
  
  def resend_new_account_confirmation
    @user = User.find(params[:id])
    @user.send_account_confirmation
    sign_in(@user, false)
    flash[:notice] = "Your account confirmation link has been resent"
    redirect_to @user
  end
  
  def get_more_karma_live_records
    @replace_content = params[:replace] == "true"
    set_karma_live_panel
  end
  
  def show_recognition_detail
    @recognition_type_id = params[:recognition_type_id].to_i
    @user_id = params[:user_id]
    @recognition_id = params[:recognition_id]
    @count = params[:count]
    @recognition_type_compliment_id = RecognitionType.COMPLIMENT.id
    @recognition_type_reward_id = RecognitionType.REWARD.id
    @recognition_type_accomplishment_id = RecognitionType.ACCOMPLISHMENT.id
    set_detail_variables
    logger.info("recognition_type_id: #{@recognition_type_id} | recognition_id: #{@recognition_id}")
    if @recognition_type_id == @recognition_type_compliment_id
      set_compliment_detail
    elsif @recognition_type_id == @recognition_type_reward_id
      set_reward_detail
    elsif @recognition_type_id == @recognition_type_accomplishment_id
      set_accomplishment_detail
    end
    render_detail_view
  end

  def render_detail_view
    if @recognition_id
      respond_to do |format|
        format.js {render 'users/fancyboxes/show_detail'}
        format.html {render 'users/fancyboxes/dev_compliment'}
      end
    else
      render :nothing => true
    end
  end
  
  def set_compliment_detail
    logger.info('Compliment Detail')
    @compliment_popup = Compliment.find(@recognition_id)
    if @compliment_popup
      @sender = @compliment_popup.get_sender
      @receiver = @compliment_popup.get_receiver
      @updated_at = @compliment_popup.updated_at
      @compliment_type = "Unspecified"
      @compliment_type = @compliment_popup.compliment_type.name if @compliment_popup.compliment_type
    end
  end
  
  def set_reward_detail
    logger.info('Reward Detail')
    @reward = Reward.find(@recognition_id)
    if @reward
      @user = @reward.receiver
      @updated_at = @reward.updated_at
      @presenter = @reward.presenter
    end      
  end
  
  def set_accomplishment_detail
    logger.info('Accomplishment Detail')
    @user_accomplishment = UserAccomplishment.find(@recognition_id)
    if @user_accomplishment
      @user = @user_accomplishment.user
      @updated_at = @user_accomplishment.updated_at
      @accomplishment = @user_accomplishment.accomplishment
      @ck_likes = CkLike.get_all_accomplishment_likes(@user_accomplishment.id)
      @comments = RecognitionComment.get_all_accomplishment_comments(@user_accomplishment.id)
    end
  end

  def dev_popup
    @compliment_popup = Compliment.last
    set_detail_variables(@compliment_popup.id)
    render_detail_view
  end

  # Non route methods
  def set_title
    first_name = "#{@user.first_name} " || ""
    middle_name = "#{@user.middle_name} " || ""
    last_name = "#{@user.last_name} " || ""
    @title = "#{first_name}#{middle_name}#{last_name}Profile"
  end

  def set_detail_variables
    @ck_likes = CkLike.get_all_likes(@recognition_id, @recognition_type_id)
    @likes_count = @ck_likes.count
    @likes_users = likes_users(@ck_likes)
    @comments = RecognitionComment.get_all_comments(@recognition_id, @recognition_type_id)
    @compliment_new = Compliment.new
    @comment_new = RecognitionComment.new
  end

  def likes_users(likes)
    if likes.nil? 
      return
    end
    likes_users = []
    likes.each do |like|
      u = User.find(like.user_id)
      likes_users << u unless u.nil?
    end
    return likes_users
  end
  
  def set_pending_items
    set_pending_relationships
  end
  
  def set_pending_relationships
    @pending_items = {}
    @pending_items_count = 0
    pending_relationships = Relationship.get_pending_relationships(@user)
    @pending_items_count = pending_relationships.count if pending_relationships
    logger.info("Pending Items Count: #{@pending_items_count}")
    if(pending_relationships && pending_relationships.size > 0)
      users = []
      pending_relationships.each do |r|
        u = User.find(r.user_1_id)
        users << u
      end
      @pending_items[:relationships] = users
    end
  end
  
  def set_this_week_compliments
    @compliments_since_last_monday = Compliment.get_compliments_since_monday(@user)
  end
  
  ## return hash of skill and number of occurrences
  def compliment_count_by_skill(compliments)
    return if compliments.nil?
    h = Hash.new(0)
    compliments.each do |compliment|
      h[compliment.skill_id] += 1
    end

    return h.sort_by{ |k,v| v }.reverse
  end

  def account_settings
  end

  # There is a path through which a user is retrieved from the update history.
  # in those cases we need to set the update history read status
  def set_update_history_read
    update_history_id = params[:update_history_id]
    return if update_history_id.blank?
    update_history = UpdateHistory.find(update_history_id)
    update_history.set_read
  end

  def switch_accounts
    logger.info("Before Current User " + current_user.name)
    logger.info("Before Current User 2 " + current_user_2.name) if current_user_2
    new_user = User.find(params[:id])
    set_current_user_2(current_user) #move the current user to user 2
    sign_in(new_user, false) # sign in the new user
    logger.info("Current User " + current_user.name)
    logger.info("Current User 2 " + current_user_2.name)
    redirect_to current_user
  end

  private
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      good_user = current_user?(@user)
      # if company_user?
      #   good_user = current_user.is_company_administrator?(@user.company.id)
      # end
      redirect_to(root_path) unless good_user
    end

    def get_confirmation_status
      @user = User.find(params[:id])
      @confirmed = @user.confirmed? if @user
    end

    def hide_unconfirmed_user
      if !current_user?(@user) && !@user.confirmed?
        flash[:error] = "Sorry, Page not Found"
        redirect_to root_path
      end
    end

    def set_static_vars
      @page = (params[:page] || 1).to_i
      @per_page = 10
      @compliment = Compliment.new
      @my_update_items_count = UpdateHistory.get_recent_item_count(my_updates_user)
    end

    def my_updates_user
      user = current_user
      user = @user if view_state(@user) == view_state_company_manager
      return user
    end

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
    
    def get_karma_live_items(feed_item_type_id, relation_type_id)
      # logger.info("User get feed items: #{feed_item_type_id} | #{relation_type_id}")
      # case feed_item_type_id.to_i
      # when FeedItemType.ONLY_COMPLIMENTS.id
      #   logger.info("Only Compliments")
      #   compliments = Compliment.compliment_by_relation_item_type(@user, relation_type_id)
      # when FeedItemType.ONLY_REWARDS.id
      #   logger.info("Only Rewards")
      #   rewards = UserReward.rewards_from_followed(@user)
      # when FeedItemType.ONLY_ACCOMPLISHMENTS.id
      #   logger.info("Only Accomplishments")
      #   accomplishments = UserAccomplishment.accomplishments_from_followed(@user)
      # else
      #   logger.info("Everything")
      #   compliments = Compliment.compliment_by_relation_item_type(@user, relation_type_id)
      #   rewards = UserReward.rewards_from_followed(@user)
      #   accomplishments = UserAccomplishment.accomplishments_from_followed(@user)
      # end
      # FeedItem.construct_items(compliments, rewards, accomplishments)

      # Use this until the filtering is needed
      if current_user?(@user)
        compliments = Compliment.all_compliments_from_followed(@user)
        rewards = Reward.rewards_from_followed(@user)
        accomplishments = UserAccomplishment.accomplishments_from_followed(@user)
      else
        compliments = Compliment.all_active_compliments(@user)
        rewards = Reward.all_completed_rewards(@user)
        accomplishments = @user.accomplishments
      end
      FeedItem.construct_items(compliments, rewards, accomplishments)
    end

end
