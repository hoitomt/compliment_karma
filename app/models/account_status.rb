class AccountStatus < ActiveRecord::Base
  has_many :users
  
  validates_uniqueness_of :name
  
  def self.UNCONFIRMED
    return find_by_name('Unconfirmed')
  end
  
  def self.CONFIRMED
    return find_by_name('Confirmed')
  end
  
  def self.TERMINATED
    return find_by_name('Terminated')
  end
end
