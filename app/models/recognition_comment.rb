class RecognitionComment < ActiveRecord::Base

  validates_presence_of :comment, :recognition_id, :recognition_type_id
  
  default_scope :order => 'created_at ASC'

  def update_history(current_user)
    if self.recognition_type_id == RecognitionType.COMPLIMENT.id
      UpdateHistory.Comment_on_Sent_Compliment(self, current_user.id)
      UpdateHistory.Comment_on_Received_Compliment(self, current_user.id)
    elsif self.recognition_type_id == RecognitionType.REWARD.id
      UpdateHistory.Comment_on_Reward(self, current_user.id)
    elsif self.recognition_type_id == RecognitionType.ACCOMPLISHMENT.id
      UpdateHistory.Comment_on_Accomplishment(self, current_user.id)
    end
  end

  def self.get_count(recognition_object_id, recognition_type_id)
    RecognitionComment.where('recognition_id = ? and recognition_type_id = ?', 
                              recognition_object_id, recognition_type_id).count
  end
  
  def self.get_all_comments(recognition_id, recognition_type_id)
    RecognitionComment.where('recognition_id = ? and recognition_type_id = ?', 
                  recognition_id, recognition_type_id)
  end

  # The recognition_id is the compliment_id
  def self.get_all_compliment_comments(recognition_id)
    get_all_comments(recognition_id, RecognitionType.COMPLIMENT.id)
  end
  
  # The recognition_id is the reward_id
  def self.get_all_reward_comments(recognition_id)
    get_all_comments(recognition_id, RecognitionType.REWARD.id)
  end
  
  # The recognition_id is the user_accomplishment_id
  def self.get_all_accomplishment_comments(recognition_id)
    get_all_comments(recognition_id, RecognitionType.ACCOMPLISHMENT.id)
  end
end
