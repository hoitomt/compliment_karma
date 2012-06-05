class CkLike < ActiveRecord::Base
  belongs_to :recognition_type
  belongs_to :user
  
  validates_presence_of :recognition_id, :recognition_type_id, :user_id
  # A User can only like something once
  validates_uniqueness_of :user_id, :scope => [:recognition_id, :recognition_type_id],
                          :message => "You have already liked this item"
  
  def update_history(current_user)
    logger.info('Update History')
    if self.recognition_type_id == RecognitionType.COMPLIMENT.id
      UpdateHistory.Like_Sent_Compliment(self, current_user.id)
      UpdateHistory.Like_Received_Compliment(self, current_user.id)
    elsif self.recognition_type_id == RecognitionType.REWARD.id
      UpdateHistory.Like_Reward(self, current_user.id)
    elsif self.recognition_type_id == RecognitionType.ACCOMPLISHMENT.id
      UpdateHistory.Like_Accomplishment(self, current_user.id)
    end
  end

  def self.get_count(recognition_object_id, recognition_type_id)
    CkLike.where('recognition_id = ? and recognition_type_id = ?', 
                  recognition_object_id, recognition_type_id).count
  end
  
  def self.get_all_likes(recognition_id, recognition_type_id)
    CkLike.where('recognition_id = ? and recognition_type_id = ?', 
                  recognition_id, recognition_type_id)
  end

  def self.get_all_compliment_likes(recognition_id)
    get_all_likes(recognition_id, RecognitionType.COMPLIMENT.id)
  end
  
  def self.get_all_reward_likes(recognition_id)
    get_all_likes(recognition_id, RecognitionType.REWARD.id)
  end
  
  def self.get_all_accomplishment_likes(recognition_id)
    get_all_likes(recognition_id, RecognitionType.ACCOMPLISHMENT.id)
  end
  
  def self.get_existing(recognition_id, recognition_type_id, user_id)
    c = CkLike.where('recognition_type_id = ? and recognition_id = ? and user_id = ?',
                      recognition_type_id, recognition_id, user_id)
  end
  
  def self.get_like_status(recognition_id, recognition_type_id, user_id)
    existing = CkLike.get_existing(recognition_id, recognition_type_id, user_id)
    if existing.blank?
      return CkLike.LIKE
    else
      return CkLike.UNLIKE
    end
  end

  def self.LIKE
    return "Like"
  end

  def self.UNLIKE
    return "Unlike"
  end
  
end
