class UserReward < ActiveRecord::Base
  belongs_to :reward
  belongs_to :user


end
