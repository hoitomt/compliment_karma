class RecognitionController < ApplicationController
  before_filter :authenticate
  
  def show
  	@recognition_type_id = params[:recognition_type_id].to_i
  	@recognition_id = params[:recognition_id].to_i
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
  end
  
  def set_detail_variables
    @ck_likes = CkLike.get_all_likes(@recognition_id, @recognition_type_id)
    @likes_count = @ck_likes.count
    @likes_users = likes_users(@ck_likes)
    @comments = RecognitionComment.get_all_comments(@recognition_id, @recognition_type_id)
    @compliment_new = Compliment.new
    @comment_new = RecognitionComment.new
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
      @compliment_type_id = @compliment_popup.compliment_type.id if @compliment_popup.compliment_type
    end
  end
  
  def set_reward_detail
    logger.info('Reward Detail')
    @user_reward = UserReward.find(@recognition_id)
    if @user_reward
      @user = @user_reward.user
      @reward = @user_reward.reward
      @updated_at = @user_reward.updated_at
      @presenter = User.find_by_id(@user_reward.presenter_id)
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

  def likes_users(likes)
    return if likes.nil?
    likes_users = []
    likes.each do |like|
      u = User.find(like.user_id)
      likes_users << u unless u.nil?
    end
    return likes_users
  end
  
  private
    
    def authenticate
      deny_access unless signed_in?
    end

end
