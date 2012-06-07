class Follow < ActiveRecord::Base

  # Can only follow somebody once
  validates_uniqueness_of :subject_user_id, :scope => [:follower_user_id],
                          :message => "You are already following this person"
  validate :cannot_follow_self

  after_create :update_history_create

  def cannot_follow_self
    if(self.subject_user_id == self.follower_user_id)
      errors.add(:subject_user_id, "You cannot follow yourself")
    end    
  end

  def update_history_create
    UpdateHistory.Following_You(self)
  end

  def self.follow_exists?(subject_user_id, follower_user_id)
    f = get_follow(subject_user_id, follower_user_id)
    return !f.blank?
  end

  def self.get_follow(subject_user_id, follower_user_id)
    Follow.where('subject_user_id = ? AND follower_user_id = ?', subject_user_id, follower_user_id)[0]
  end

  def self.followers(user_id)
    Follow.where('subject_user_id = ?', user_id).count
  end

  def self.following(user_id)
    Follow.where('follower_user_id = ?', user_id).count
  end

end
