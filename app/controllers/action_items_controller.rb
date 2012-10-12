class ActionItemsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user
	before_filter :set_compliment_panel
  before_filter :get_confirmation_status, :except => [:new, :create]

	def index
		@action_items = ActionItem.incomplete_for_user(@user)
		@action_items_count = @action_items.count
	end

  def pre_accept
    @action_item = ActionItem.find(params[:id])
    @originator = User.find(params[:originator_user_id])
    @groups = @user.groups.where(:display_ind => 'Y')
  end

  def accept
    @action_item = ActionItem.find(params[:id])
    originator = User.find(params[:originator_id])
    groups = params[:groups]
    group_names = []
    logger.info("Groups #{groups}")
    groups.try(:each) do |k,v|
      logger.info("LOOP Groups #{k} => #{v}")
      if v.downcase == 'yes'
        logger.info("YES")
        Contact.create(:group_id => k, :user_id => originator.id)
        group_names << Group.find_by_id(k).try(:name)
      end
    end
    accept_relationship(originator)
    if @action_item.set_complete
      @action_item.send_accept_notification
      flash[:notice] = "#{originator.full_name} has been added as a contact in the following groups: 
                        #{group_names.join(', ')}"
      redirect_to @user
    end
  end

  def decline
    @action_item = ActionItem.find(params[:id])
    originator = User.find_by_id(params[:originator_user_id])
    decline_relationship(originator)
    logger.info("Action Item: #{@action_item.inspect}")
    if @action_item.recognition_type_id == RecognitionType.COMPLIMENT.id
      compliment = Compliment.find_by_id(@action_item.recognition_id)
      logger.info("Compliment: #{compliment.try(:inspect)}")
      compliment.try(:decline)
    end
    if @action_item.set_complete
      @action_item.send_decline_notification
      flash[:notice] = "You have chosen not to accept compliments from #{originator.try(:first_last)}"
      redirect_to @user
    end
  end

  def accept_relationship(originator)
    relationship = Relationship.get_relationship(originator, @user)
    relationship.accept_relationship unless relationship.blank?
  end

  def decline_relationship(originator)
    relationship = Relationship.get_relationship(originator, @user)
    relationship.decline_relationship unless relationship.blank?
  end

	private
    def authenticate
      store_location
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:user_id])
      good_user = current_user?(@user)
      redirect_to(root_path) unless good_user
    end

    def get_confirmation_status
      @confirmed = @user.blank? ? false: @user.confirmed?
    end
end
