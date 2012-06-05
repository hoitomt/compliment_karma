class RecognitionType < ActiveRecord::Base
  has_many :ck_likes
  
  validates_uniqueness_of :name

  def self.COMPLIMENT
    find_by_name('Compliment')
  end
  
  def self.REWARD
    find_by_name('Reward')
  end
  
  def self.ACCOMPLISHMENT
    find_by_name('Accomplishment')
  end
  
end
