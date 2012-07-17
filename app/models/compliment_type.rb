class ComplimentType < ActiveRecord::Base
  has_many :compliments
  
  validates_uniqueness_of :name
  
  def self.PROFESSIONAL_TO_PROFESSIONAL
    find_by_name('Professional to Professional')
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
    return compliment_type_id == ComplimentType.PROFESSIONAL_TO_PROFESSIONAL.id ||
           compliment_type_id == ComplimentType.PROFESSIONAL_TO_PERSONAL.id
  end

  def self.professional_send_ids
    return [
      self.PROFESSIONAL_TO_PROFESSIONAL.id, 
      self.PROFESSIONAL_TO_PERSONAL.id
    ]
  end

  def self.professional_receive_ids
    return [
      self.PROFESSIONAL_TO_PROFESSIONAL.id,
      self.PERSONAL_TO_PROFESSIONAL.id
    ]
  end

  def self.social_send_ids
    return [
      self.PERSONAL_TO_PROFESSIONAL.id,
      self.PERSONAL_TO_PERSONAL.id
    ]
  end

  def self.social_receive_ids
    return [
      self.PROFESSIONAL_TO_PERSONAL.id,
      self.PERSONAL_TO_PERSONAL.id
    ]
  end

  def self.compliment_type_list(sender_is_a_company, receiver_is_a_company)
    logger.info("Sender is a company: #{sender_is_a_company} \n" +
                "Receiver is a company: #{receiver_is_a_company}")
    compliment_types = []
    if sender_is_a_company.to_s == "true" && receiver_is_a_company.to_s == "true"
      compliment_types = [ComplimentType.PROFESSIONAL_TO_PROFESSIONAL]
    elsif sender_is_a_company.to_s == "true"
      compliment_types = [ComplimentType.PROFESSIONAL_TO_PROFESSIONAL,
                           ComplimentType.PROFESSIONAL_TO_PERSONAL]
    elsif receiver_is_a_company.to_s == "true"
      compliment_types = [ComplimentType.PROFESSIONAL_TO_PROFESSIONAL,
                           ComplimentType.PERSONAL_TO_PROFESSIONAL]
    else
      compliment_types = ComplimentType.all
    end
    return compliment_types
  end

end
