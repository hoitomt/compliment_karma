class UserEmail < ActiveRecord::Base
	belongs_to :user

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates_presence_of :user_id, :domain
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
	validates :confirmed, 
						:inclusion => { :in => %w(Y N),
														:message => "The confirmed indicator must by Y or N"}
	validates :primary, 
						:inclusion => { :in => %w(Y N),
														:message => "The primary email address indicator must by Y or N"}

  before_validation :set_domain
  before_validation :set_confirmed
  before_validation :set_primary

  def is_primary?
  	self.primary == 'Y'
  end
  
  def set_domain
  	return if self.email.blank?
  	return unless self.domain.blank?
    domain_array = self.email.split('@')
    self.domain = domain_array.last
  end

  def set_confirmed
  	self.confirmed = "N" if self.confirmed.blank?
  end

  def set_primary
  	return if self.user_id.blank?
  	addresses = User.find(self.user_id).email_addresses
  	if addresses.keep_if{ |a| a.is_primary? }.blank?
  		self.primary = "Y"
  	else
  		self.primary = "N"
  	end
  end

  def set_primary_override
  	addresses =  User.find(self.user_id).email_addresses
  	addresses.each { |e| e.update_attributes(:primary => "N") }
  	self.update_attributes(:primary => "Y")
  end
  
  def compliment_cannot_be_to_self
    if(self.sender_email == self.receiver_email)
      errors.add(:receiver_email, 
                  "We think you are wonderful too but you cannot compliment yourself") 
    end
  end

end
