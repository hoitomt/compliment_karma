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

  def self.LEVEL_1_REWARDER
    find_by_name('Level 1 Rewarder')
  end
  
  def self.LEVEL_2_REWARDER
    find_by_name('Level 2 Rewarder')
  end
  
  def self.LEVEL_3_REWARDER
    find_by_name('Level 3 Rewarder')
  end
  
  def self.LEVEL_4_REWARDER
    find_by_name('Level 4 Rewarder')
  end
  
  def self.LEVEL_5_REWARDER
    find_by_name('Level 5 Rewarder')
  end

  def self.badge(count)
    if count >= Accomplishment.GRAND_MASTER_BADGE.threshold
      return Accomplishment.GRAND_MASTER_BADGE
    elsif count >= Accomplishment.MASTER_BADGE.threshold
      return Accomplishment.MASTER_BADGE
    elsif count >= Accomplishment.NINJA_BADGE.threshold
      return Accomplishment.NINJA_BADGE
    elsif count >= Accomplishment.ASPIRANT_BADGE.threshold
      return Accomplishment.ASPIRANT_BADGE
    end
  end

  def self.complimenter_level(count)
    if count > Accomplishment.LEVEL_5_COMPLIMENTER.threshold
      return Accomplishment.LEVEL_5_COMPLIMENTER
    elsif count > Accomplishment.LEVEL_4_COMPLIMENTER.threshold
      return Accomplishment.LEVEL_4_COMPLIMENTER
    elsif count > Accomplishment.LEVEL_3_COMPLIMENTER.threshold
      return Accomplishment.LEVEL_3_COMPLIMENTER
    elsif count > Accomplishment.LEVEL_2_COMPLIMENTER.threshold
      return Accomplishment.LEVEL_2_COMPLIMENTER
    elsif count > Accomplishment.LEVEL_1_COMPLIMENTER.threshold
      return Accomplishment.LEVEL_1_COMPLIMENTER
    end
  end

  def self.rewarder_level(count)
    if count > Accomplishment.LEVEL_5_REWARDER.threshold
      return Accomplishment.LEVEL_5_REWARDER
    elsif count > Accomplishment.LEVEL_4_REWARDER.threshold
      return Accomplishment.LEVEL_4_REWARDER
    elsif count > Accomplishment.LEVEL_3_REWARDER.threshold
      return Accomplishment.LEVEL_3_REWARDER
    elsif count > Accomplishment.LEVEL_2_REWARDER.threshold
      return Accomplishment.LEVEL_2_REWARDER
    elsif count > Accomplishment.LEVEL_1_REWARDER.threshold
      return Accomplishment.LEVEL_1_REWARDER
    end
  end
end

