class Visibility < ActiveRecord::Base
  has_many :compliments
  has_many :relationships

  validates_uniqueness_of :name

  def self.SENDER_AND_RECEIVER
    find_by_name('sender and receiver')
  end
  
  def self.COWORKERS_FROM_THIS_JOB
    find_by_name('coworkers from this job')
  end
  
  def self.COWORKERS_FROM_ALL_JOBS
    find_by_name('coworkers from all jobs')
  end
  
  def self.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_THIS_JOB
    find_by_name('coworkers and external contacts from this job')
  end
  
  def self.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_ALL_JOBS
    find_by_name('coworkers and external contacts from all jobs')
  end
  
  def self.EVERYBODY
    find_by_name('everybody')
  end
  
  def self.all_visibility_ids
    [
      self.SENDER_AND_RECEIVER.id,
      self.COWORKERS_FROM_THIS_JOB.id,
      self.COWORKERS_FROM_ALL_JOBS.id,
      self.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_THIS_JOB.id,
      self.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_ALL_JOBS.id,
      self.EVERYBODY.id
    ]
  end

end
