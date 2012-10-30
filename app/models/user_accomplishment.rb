class UserAccomplishment < ActiveRecord::Base
  belongs_to :user
  belongs_to :accomplishment
  has_one :recognition, :foreign_key => :recognition_id,
                        :conditions => {:recognition_type_id => RecognitionType.ACCOMPLISHMENT.id}, 
                        :dependent => :destroy

  after_create :update_history
  after_create :create_recognition

  def update_history
    logger.info("Create Update History")
    UpdateHistory.Earned_an_Accomplishment(self)
  end

  def create_recognition
    Recognition.create_from_user_accomplishment(self)
  end

  def self.accomplishments_from_followed(user)
    followed = Follow.find_all_by_follower_user_id(user.id)
    f_array = followed.collect{|x| x.subject_user_id}
    UserAccomplishment.where('user_id in (?)', f_array)
  end
end
