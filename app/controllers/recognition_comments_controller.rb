class RecognitionCommentsController < ApplicationController
  before_filter :authenticate
  
  def create
    @rc = RecognitionComment.new(params[:recognition_comment])
    @count = params[:count]
    if @rc.save
      logger.info("Current User: #{current_user}")
      @rc.update_history(current_user)
    else
      flash[:recognition_comment_errors] = parse_errors_into_array.join("\n")
    end
    handle_redirect
  end
  
  def handle_redirect
    @comments_count = RecognitionComment.get_count(@rc.recognition_id, @rc.recognition_type_id)
    render 'comments_count_user_profile'
  end
  
  private
    def authenticate
      deny_access unless signed_in?
    end
    
    def parse_errors_into_array
      a = []
      @rc.errors.messages.each do |k,v|
        a << v
      end
      return a
    end
end
