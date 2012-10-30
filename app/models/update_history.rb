class UpdateHistory < ActiveRecord::Base
	belongs_to :update_history_type
  belongs_to :user
  belongs_to :originating_user, :class_name => "User", :foreign_key => 'originating_user_id'
  default_scope :order => 'created_at DESC'

  def self.get_recent_item_count(user)
    return 0 if user.nil?
    as_of_date = user.last_read_notification_date || DateTime.new(2012, 1, 1)
    items = UpdateHistory.where('user_id = ? AND created_at > ?', 
                                user.id, as_of_date)
    return items.count
  end

  def self.get_recent_update_history(user)
    UpdateHistory.where('user_id = ?', user.id).first(5)
  end

  def unread?
    return self.read != "true"
  end

  def set_read
    self.update_attributes(:read => "true")
  end

  def self.add_update_history(user_id, update_history_type_id, recognition_type_id, 
                              recognition_id, note, originating_user_id)
    logger.info("Add Update History: #{originating_user_id}|#{user_id}")
  	unless(originating_user_id == user_id)
      self.create(:user_id => user_id,
                  :update_history_type_id => update_history_type_id,
    							:recognition_type_id => recognition_type_id,
    							:recognition_id => recognition_id,
    							:note => note,
                  :originating_user_id => originating_user_id)
    end
  end

  def self.add_update_history_no_duplicates (user_id, update_history_type_id, 
                                            recognition_type_id, recognition_id, 
                                            note, originating_user_id)
    logger.info("Add Update History: #{originating_user_id}|#{user_id}")
    return if is_duplicate?(user_id, update_history_type_id, recognition_type_id,
                            recognition_id, originating_user_id)
    unless(originating_user_id == user_id)
      self.create(:user_id => user_id,
                  :update_history_type_id => update_history_type_id,
                  :recognition_type_id => recognition_type_id,
                  :recognition_id => recognition_id,
                  :note => note,
                  :originating_user_id => originating_user_id)
    end
  end

  def self.Like_Sent_Compliment(ck_like, current_user_id)
    c = Compliment.find_by_id(ck_like.recognition_id)
    add_update_history_no_duplicates( c.sender_user_id,
                        UpdateHistoryType.Like_Sent_Compliment.id,
                        ck_like.recognition_type_id,
                        ck_like.recognition_id,
                        "liked your compliment to #{c.receiver_name}", current_user_id)
  end

  def self.Like_Received_Compliment(ck_like, current_user_id)
    c = Compliment.find_by_id(ck_like.recognition_id)
	  add_update_history_no_duplicates( c.receiver_user_id,
                        UpdateHistoryType.Like_Received_Compliment.id,
                        ck_like.recognition_type_id,
                        ck_like.recognition_id,
                        "liked your compliment from #{c.get_sender.first_last}", current_user_id)
  end

  def self.Like_Reward(ck_like, current_user_id)
    r = Reward.find_by_id(ck_like.recognition_id)
    reward_presenter = User.find_by_id(r.presenter_id).first_last unless r.presenter_id.blank?
    note = "liked your reward"
    note += " from #{reward_presenter}" unless reward_presenter.blank?
    add_update_history_no_duplicates( r.receiver_id,
                        UpdateHistoryType.Like_Reward.id,
                        ck_like.recognition_type_id,
                        ck_like.recognition_id,
                        note, current_user_id)
    
  end

  def self.Like_Accomplishment(ck_like, current_user_id)
    logger.info(ck_like.recognition_id)
    a = UserAccomplishment.find_by_id(ck_like.recognition_id)
    add_update_history_no_duplicates( a.user_id,
                        UpdateHistoryType.Like_Accomplishment.id,
                        ck_like.recognition_type_id,
                        ck_like.recognition_id,
                        "liked your #{a.accomplishment.name} badge", current_user_id)
  end

  def self.Received_Compliment(compliment)
    add_update_history(compliment.receiver_user_id, 
                       UpdateHistoryType.Received_Compliment.id,
                       RecognitionType.COMPLIMENT.id,
                       compliment.id,
                       "sent you a Compliment", compliment.sender_user_id)
  end

  def self.Following_You(follow)
    subject = User.find_by_id(follow.subject_user_id)
    follower = User.find_by_id(follow.follower_user_id)
    return if is_duplicate_uh_follow?(follow.subject_user_id, 
                                      UpdateHistoryType.Following_You.id,
                                      follow.follower_user_id)
    add_update_history( follow.subject_user_id,
                        UpdateHistoryType.Following_You.id,
                        nil,
                        nil,
                        "is following you", follow.follower_user_id)
  end

  def self.Comment_on_Sent_Compliment(recognition_comment, current_user_id)
    c = Compliment.find_by_id(recognition_comment.recognition_id)
    add_update_history( c.sender_user_id,
                        UpdateHistoryType.Comment_on_Sent_Compliment.id,
                        recognition_comment.recognition_type_id,
                        recognition_comment.recognition_id,
                        "commented on your compliment to #{c.receiver_name}", current_user_id)
  end

  def self.Comment_on_Received_Compliment(recognition_comment, current_user_id)
    c = Compliment.find_by_id(recognition_comment.recognition_id)
    add_update_history( c.receiver_user_id,
                        UpdateHistoryType.Comment_on_Received_Compliment.id,
                        recognition_comment.recognition_type_id,
                        recognition_comment.recognition_id,
                        "commented on your compliment from #{c.get_sender.first_last}", current_user_id)
  end

  def self.Comment_on_Reward(recognition_comment, current_user_id)
    r = Reward.find_by_id(recognition_comment.recognition_id)
    reward_presenter = User.find_by_id(r.presenter_id).first_last unless r.presenter_id.blank?
    note = "commented on your #{r.value} reward"
    note += " from #{reward_presenter}" unless reward_presenter.blank?
    add_update_history( r.receiver_id,
                        UpdateHistoryType.Comment_on_Reward.id,
                        recognition_comment.recognition_type_id,
                        recognition_comment.recognition_id,
                        note, current_user_id)
  end  
  
  def self.Comment_on_Accomplishment(recognition_comment, current_user_id)
    a = UserAccomplishment.find_by_id(recognition_comment.recognition_id)
    add_update_history( a.user_id,
                        UpdateHistoryType.Comment_on_Accomplishment.id,
                        recognition_comment.recognition_type_id,
                        recognition_comment.recognition_id,
                        "commented on your #{a.accomplishment.name} badge", current_user_id)
  end

  def self.Earned_an_Accomplishment(user_accomplishment)
    a = user_accomplishment.accomplishment
    add_update_history( user_accomplishment.user_id,
                        UpdateHistoryType.Earned_an_Accomplishment.id,
                        RecognitionType.ACCOMPLISHMENT.id,
                        user_accomplishment.id,
                        "earned a #{a.name} badge by sending a compliment", nil)
  end

  def self.Received_Reward(reward)
    reward_presenter = User.find_by_id(reward.presenter_id).first_last unless 
                            reward.presenter_id.blank?
    value = "$%6.2f" % reward.value
    note = "received a #{value} reward"
    note += " from #{reward_presenter}" unless reward_presenter.blank?
    add_update_history( reward.receiver_id,
                        UpdateHistoryType.Received_Reward.id,
                        RecognitionType.REWARD.id,
                        reward.id,
                        note, reward.presenter_id)
  end

  def self.Accepted_Compliment_Receiver(action_item)
    add_update_history(action_item.originating_user_id,
                       UpdateHistoryType.Accepted_Compliment_Receiver.id,
                       nil,
                       nil,
                       "accepted your compliment", action_item.user_id)
  end

  def self.Rejected_Compliment_Receiver(action_item)
    add_update_history(action_item.originating_user_id,
                       UpdateHistoryType.Rejected_Compliment_Receiver.id,
                       nil,
                       nil,
                       "rejected your compliment", action_item.user_id)
  end

  def self.is_duplicate?(user_id, update_history_type_id, recognition_type_id, 
                              recognition_id, originating_user_id)
    existing_update_history = UpdateHistory.where('user_id = ? and update_history_type_id = ? ' +
                                                  'and recognition_type_id = ? and recognition_id = ? ' +
                                                  'and originating_user_id = ?',
                                                  user_id, update_history_type_id, recognition_type_id,
                                                  recognition_id, originating_user_id)
    logger.info("Update History is Duplicate") unless existing_update_history.blank?
    return !existing_update_history.blank?
  end

  def self.is_duplicate_uh_follow?(subject_user_id, update_history_type_id, originating_user_id)
    existing_update_history = UpdateHistory.where('user_id = ? and update_history_type_id = ? ' +
                                                  'and originating_user_id = ?',
                                                  subject_user_id, update_history_type_id, originating_user_id)
    logger.info("Update History is Duplicate") unless existing_update_history.blank?
    return !existing_update_history.blank?
  end

end
