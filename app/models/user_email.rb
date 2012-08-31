class UserEmail < ActiveRecord::Base
	belongs_to :user

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates_presence_of :user_id
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
	# validates :confirmed, 
	# 					:inclusion => { :in => %w(Y N),
	# 													:message => "The confirmed indicator must by Y or N"}
	# validates :primary, 
	# 					:inclusion => { :in => %w(Y N),
	# 													:message => "The primary email address indicator must by Y or N"}

  before_create :set_domain
  before_create :set_confirmed
  before_create :set_primary
  # before_validation :set_domain
  # before_validation :set_confirmed
  # before_validation :set_primary
  after_save :update_redis
  after_save :associate_compliments
  after_destroy :update_redis
  after_destroy :disassociate_compliments

  default_scope :order => 'primary_email DESC, confirmed DESC, email ASC'

  def is_primary?
  	self.primary_email == 'Y'
  end

  # def self.primary?
  #   where("primary_email = ?", 'Y')
  # end

  def is_confirmed?
    self.confirmed == 'Y'
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

  def confirm_email
    update_attributes(:confirmed => 'Y')
  end

  def set_primary
    logger.info("Set Primary for Email #{self.email}")
  	return if self.user_id.blank?
  	addresses = User.find(self.user_id).email_addresses
  	if addresses.keep_if{ |a| a.is_primary? }.blank?
  		self.primary_email = "Y"
  	else
  		self.primary_email = "N"
  	end
  end

  def set_primary_override
    logger.info("Set Primary Override")
    current_primary_email = self.user.primary_email
    current_primary_email.update_attributes(:primary_email => "N")
  	# addresses = self.user.email_addresses
  	# addresses.each { |e| e.update_attributes(:primary_email => "N") }
  	self.update_attributes(:primary_email => "Y")
  end
  
  def compliment_cannot_be_to_self
    if(self.sender_email == self.receiver_email)
      errors.add(:receiver_email, 
                  "We think you are wonderful too but you cannot compliment yourself") 
    end
  end

  def update_redis
    u = self.user
    u.add_to_redis
  end

  def associate_compliments
    Compliment.update_receiver_user_id(self.user_id, self.email)
  end

  def disassociate_compliments
    Compliment.update_receiver_user_id(nil, self.email)
  end

  def send_email_confirmation
    generate_new_email_confirmation_token
    UserMailer.new_email_confirmation(self).deliver
  end

  def generate_new_email_confirmation_token
    generate_token(:new_email_confirmation_token)
    save!
  end

  def generate_token(column)
    begin
      logger.info("Generate Token: #{column}")
      self[column] = SecureRandom.urlsafe_base64
    end while UserEmail.exists?(column => self[column])
  end

end
