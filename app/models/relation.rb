## Used to define the relation of the person to whom a compliment is being sent
class Relation < ActiveRecord::Base
  has_many :compliments
  
  def self.COWORKER
    find_by_name('Coworker')
  end
  
  def self.CLIENT
    find_by_name('Client')
  end
  
  def self.BUSINESS_PARTNER
    find_by_name('Business Partner')
  end
  
  def self.SERVICE_PROVIDER
    find_by_name('Service Provider')
  end
  
  def self.internal?(relation_name)
    r = find_by_name(relation_name)
    return !r.blank? && r.category == "Internal"
  end
  
  def self.external?(relation_name)
    r = find_by_name(relation_name)
    return !r.blank? && r.category == "External"
  end

end
