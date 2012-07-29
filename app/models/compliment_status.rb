class ComplimentStatus < ActiveRecord::Base
  has_many :compliments

  validates_uniqueness_of :name
  
  def self.ACTIVE
    find_by_name('Active')
  end
  
  def self.PENDING_RECEIVER_CONFIRMATION
    find_by_name('Pending Receiver Confirmation')
  end

  def self.PENDING_RECEIVER_REGISTRATION
    find_by_name('Pending Receiver Registration')
  end

  def self.MISSING_INFORMATION
    find_by_name('Missing Information')
  end
  
  def self.WITHDRAWN
    find_by_name('Withdrawn')
  end
  
end
