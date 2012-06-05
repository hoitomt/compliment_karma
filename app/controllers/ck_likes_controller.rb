class CkLikesController < ApplicationController
  before_filter :authenticate
  
  def create
    recognition_type_id = params[:recognition_type_id]
    recognition_id = params[:recognition_id]
    user_id = params[:user_id]
    @count = params[:count]
    
    existing = CkLike.get_existing(recognition_id, recognition_type_id, user_id)
    if existing.blank?
      @ck = CkLike.new( :recognition_type_id => recognition_type_id,
                        :recognition_id => recognition_id, 
                        :user_id => user_id )
      @ck.save
      @ck.update_history(current_user)
      @liked = true
    else
      logger.info("existing record - delete it")
      existing[0].delete
      @liked = false
    end
    @like_status = CkLike.get_like_status(recognition_id, recognition_type_id, user_id)
    @likes_count = CkLike.get_count(recognition_id, recognition_type_id)
    handle_redirect
  end
  
  def handle_redirect
    logger.info("Redirect")
    render 'likes_count_user_profile'
  end
  
  private
    def authenticate
      deny_access unless signed_in?
    end
    
    def parse_errors_into_array
      a = []
      @ck.errors.messages.each do |k,v|
        a << v
      end
      return a
    end
  
end
