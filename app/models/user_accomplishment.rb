class UserAccomplishment < ActiveRecord::Base
  belongs_to :user
  belongs_to :accomplishment

  after_create :update_history

  def update_history
    logger.info("Create Update History")
    UpdateHistory.Earned_an_Accomplishment(self)
  end

  def self.accomplishments_from_followed(user)
    followed = Follow.find_all_by_follower_user_id(user.id)
    list_of_accomplishments = []
    followed.each do |follow|
      u = User.find_by_id(follow.subject_user_id)
      list_of_accomplishments += u.user_accomplishments
    end
    return list_of_accomplishments
  end
end
