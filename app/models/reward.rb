class Reward < ActiveRecord::Base
  has_many :user_rewards
  has_many :users, :through => :user_rewards
  
  validates_uniqueness_of :name
  
  def self.GIFT_CARD_25
    return Reward.find_by_name('$25 Gift Card')
  end
  
  def self.GIFT_CARD_50
    return Reward.find_by_name('$50 Gift Card')
  end
  
  def self.GIFT_CARD_75
    return Reward.find_by_name('$75 Gift Card')
  end
  
  def self.GIFT_CARD_100
    return Reward.find_by_name('$100 Gift Card')
  end
end
