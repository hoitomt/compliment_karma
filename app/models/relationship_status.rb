class RelationshipStatus < ActiveRecord::Base
  has_many :relationships
  
  validates_uniqueness_of :name
  
  def self.ACCEPTED
    find_by_name('Accepted')
  end
  
  def self.PENDING
    find_by_name('Pending')
  end
  
  def self.NOT_ACCEPTED
    find_by_name('Not Accepted')
  end
  
end
