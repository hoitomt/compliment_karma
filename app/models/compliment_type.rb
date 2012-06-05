class ComplimentType < ActiveRecord::Base
  has_many :compliments
  
  validates_uniqueness_of :name
  
  def self.COWORKER_TO_COWORKER
    find_by_name('Coworker to Coworker')
  end
  
  def self.PROFESSIONAL_TO_PROFESSIONAL
    find_by_name('Professional to Professional (across companies)')
  end
  
  def self.PROFESSIONAL_TO_PERSONAL
    find_by_name('Professional to Personal')
  end
  
  def self.PERSONAL_TO_PROFESSIONAL
    find_by_name('Personal to Professional')
  end
  
  def self.PERSONAL_TO_PERSONAL
    find_by_name('Personal to Personal')
  end

  def self.is_professional?(compliment_type_id)
    return compliment_type_id == ComplimentType.COWORKER_TO_COWORKER.id ||
           compliment_type_id == ComplimentType.PROFESSIONAL_TO_PROFESSIONAL.id ||
           compliment_type_id == ComplimentType.PROFESSIONAL_TO_PERSONAL.id
  end
end
