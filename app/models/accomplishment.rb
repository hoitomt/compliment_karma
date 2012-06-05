class Accomplishment < ActiveRecord::Base
  has_many :user_accomplishments
  has_many :users, :through => :user_accomplishments
  
  validates_uniqueness_of :name
  
  def self.TROPHY
    find_by_name('Trophy')
  end
  
  def self.ASPIRANT_BADGE
    find_by_name('Aspirant Badge')
  end
  
  def self.NINJA_BADGE
    find_by_name('Ninja Badge')
  end
  
  def self.MASTER_BADGE
    find_by_name('Master Badge')
  end
  
  def self.GRAND_MASTER_BADGE
    find_by_name('Grand Master Badge')
  end
  
  def self.LEVEL_1_COMPLIMENTER
    find_by_name('Level 1 Complimenter')
  end
  
  def self.LEVEL_2_COMPLIMENTER
    find_by_name('Level 2 Complimenter')
  end
  
  def self.LEVEL_3_COMPLIMENTER
    find_by_name('Level 3 Complimenter')
  end
  
  def self.LEVEL_4_COMPLIMENTER
    find_by_name('Level 4 Complimenter')
  end
  
  def self.LEVEL_5_COMPLIMENTER
    find_by_name('Level 5 Complimenter')
  end
end

