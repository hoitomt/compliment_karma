class User < ActiveRecord::Base
  belongs_to :account_status
  # User Representation of the company
  belongs_to :company
  # Users that are company application administrators
  has_many :company_users, :dependent => :delete_all
  has_many :companies, :through => :company_users, :dependent => :delete_all
  has_many :rewards_presented, :class_name => 'Reward', 
                               :foreign_key => 'presenter_id', :dependent => :delete_all
  has_many :rewards_received, :class_name => 'Reward', 
                              :foreign_key => 'receiver_id', :dependent => :delete_all
  has_many :compliments_sent, :class_name => 'Compliment', 
                              :foreign_key => 'sender_user_id', :dependent => :delete_all
  has_many :compliments_received, :class_name => 'Compliment', 
                                  :foreign_key => 'receiver_user_id', :dependent => :delete_all
  has_many :followed_users, :class_name => 'Follow', 
                            :foreign_key => 'follower_user_id', :dependent => :delete_all
  has_many :followers, :class_name => 'Follow', 
                       :foreign_key => 'subject_user_id', :dependent => :delete_all
  has_many :user_accomplishments, :dependent => :delete_all
  has_many :accomplishments, :through => :user_accomplishments
  has_many :ck_likes, :dependent => :delete_all
  has_many :company_department_users, :dependent => :delete_all
  has_many :company_departments, :through => :company_department_users
  has_many :experiences, :dependent => :delete_all
  has_many :email_addresses, :class_name => 'UserEmail', 
                             :foreign_key => 'user_id', :dependent => :delete_all
  has_one  :primary_email, :class_name => 'UserEmail', 
                           :foreign_key => 'user_id', 
                           :conditions => "primary_email = 'Y'"
  has_many :action_items, :dependent => :delete_all
  has_many :originated_action_items, :class_name => 'ActionItem',
                                     :foreign_key => 'originating_user_id',
                                     :dependent => :delete_all
  has_many :groups, :dependent => :delete_all
  has_many :contacts, :through => :groups
  has_many :memberships, :class_name => 'Contact', 
                         :foreign_key => 'user_id', :dependent => :delete_all
  
  attr_accessor :password
  # use attr_accessible to white list vars that can be mass assigned
  attr_accessible :name, :email, :password, :password_confirmation, :photo,
                  :first_name, :middle_name, :last_name, :domain, :job_title,
                  :account_status_id, :account_status, :address_line_1, :address_line_2, 
                  :city, :state_cd, :zip_cd, :profile_url, :profile_headline, 
                  :industry_id, :company_id, :country, :last_read_notification_date,
                  :professional_intro, :social_intro
  
  has_attached_file  :photo, 
                     :styles => { :mini => "40x40>",
                                  :thumb => "60>x60",
                                  :small => "180>x180",
                                  :profile => "200>x200",
                                  :medium => "300x300>" },
                     :convert_options => { :all => '-auto-orient' },
                     :default_url => 'https://s3.amazonaws.com/compliment_karma_prod/missing/missing_:style.png',
                     :storage => :s3,
                     :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
                     :path => "/:id/:style/:filename"
                     
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  @@email_regex_loc = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true,
                   :length => { :maximum => 50 },
                   :on => :create
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false },
                    :on => :create
  validates :password, :presence => true,
                       :length => { :within => 6..40 },
                       :on => :create
  # validate :on_whitelist

  before_create :encrypt_password
  before_create :set_name
  before_create :set_domain
  before_create :set_account_status
  after_create :create_user_email
  after_create :associate_received_compliments
  after_create :associate_sent_compliments
  after_create :create_relationships
  after_create :metrics_send_new_user
  after_create :create_groups
  after_save :add_to_redis
  
  # Return true if the user's password matches the submitted password
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def is_customer_admin?
    return !self.companies.blank?
  end

  def is_site_admin?
    Domain.master_domain?(self.domain)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_user_by_email(email)
    (user && user.has_password?(submitted_password)) ? user : nil
  end

  def self.find_user_by_email(email)
    user_email = UserEmail.where('email = ?', email)
    return user_email.try(:first).try(:user)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def self.authenticate_founder(email, submitted_password)
    user = find_user_by_email(email)
    logger.info("User: #{user.name} | #{user.email} | #{user.founder}") if user
    (user && 
     user.founder &&
     user.has_password?(submitted_password)) ? user : nil
  end
  
  def self.authenticate_founder_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && 
     user.founder &&
     user.salt == cookie_salt) ? user : nil
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def generate_token(column)
    begin
      logger.info("Generate Token: #{column}")
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  # def on_whitelist
  #   unless Domain.whitelist.include?(self.set_domain)
  #     errors.add(:domain, "Must be on whitelist")
  #   end
  # end
  
  def on_whitelist?
    Domain.whitelist.include?(self.set_domain)
  end

  def set_name
    name_array = self.name.split(' ')
    if name_array.size == 1
      self.first_name = name_array[0]
    elsif name_array.size == 2
      self.first_name = name_array[0]
      self.last_name = name_array[1]
    elsif name_array.size > 2
      self.first_name = name_array[0]
      self.middle_name = name_array[1]
      self.last_name = name_array[2]
    end    
  end
  
  def full_name
    if self.is_a_company?
      return self.company.name
    else
      name = []
      name << self.first_name if self.first_name
      name << self.middle_name if self.middle_name
      name << self.last_name if self.last_name
      return name.join(' ')
    end
  end
  
  def first_last_initial
    l = self.last_name[0].capitalize if self.last_name
    return "#{self.first_name} #{l}"
  end

  def first_last
    if self.is_a_company?
      return self.company.name
    else
      if self.last_name
        return "#{self.first_name} #{self.last_name}"
      else
        return "#{self.first_name}"
      end
    end
  end

  def search_result_display
    if self.is_a_company?
      return self.company.name
    else
      # return "#{self.full_name} (#{self.email})"
      return "#{self.full_name}"
    end
  end
  
  def set_domain
    domain_array = self.email.split('@')
    self.domain = domain_array.last
  end
  
  def send_account_confirmation
    account_confirmation_token
    UserMailer.account_confirmation(self).deliver
  end

  def account_confirmation_token
    generate_token(:new_account_confirmation_token)
    save!
  end
  
  def set_account_status
    self.account_status = AccountStatus.UNCONFIRMED if self.account_status.nil?
  end
      
  def encrypt_password
    self.salt = BCrypt::Engine.generate_salt
    self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
  end
  
  def self.get_account_status(email)
    u = User.find_user_by_email(email)
    logger.info("User at this email address #{email} is blank: #{u.blank?} ")
    if u.blank?
      return nil
    else
      return u.account_status
    end
  end
  
  def self.is_internal?(user_1_id, user_2_id)    
    user_1 = User.find(user_1_id)
    user_2 = User.find(user_2_id)
    return user_1 && user_2 && user_1.domain == user_2.domain
  end
  
  def associate_received_compliments
    logger.info("Associate Received Compliments")
    my_received_compliments = Compliment.where('receiver_email = ?', self.email)
    logger.info("Number of received compliments: #{my_received_compliments.length}")
    my_received_compliments.each do |c|
      logger.info("Status = #{c.compliment_status.name}")
      new_status = update_receiver_status(c.compliment_status)
      logger.info("New Status = #{new_status.name}")
      c.update_attributes(:receiver_user_id => self.id, 
                          :compliment_status_id => new_status.id)
      ActionItem.create_from_compliment(c)
      UpdateHistory.Received_Compliment(c)
    end
  end
  
  def associate_sent_compliments
    logger.info("Associate Sent Compliments")
    my_sent_compliments = Compliment.where('sender_email = ? AND sender_user_id is null', self.email)
    my_sent_compliments.each do |c|
      c.sender_user_id = self.id
      c.compliment_status =  update_sender_status(c.compliment_status)
    end
  end
  
  def create_relationships
    received_compliments = Compliment.find_all_by_receiver_user_id(self.id)
    received_compliments.each do |compliment|
      Relationship.create(:user_1_id => compliment.sender_user_id,
                          :user_2_id => compliment.receiver_user_id)
    end
  end

  def create_groups
    Group.initialize_groups(self)
  end
  
  # Updates the status one level for the receiver
  # registration -> confirmation
  # confirmation -> active
  def update_receiver_status(compliment_status)
    case compliment_status
    when ComplimentStatus.PENDING_RECEIVER_CONFIRMATION
      return ComplimentStatus.ACTIVE
    when ComplimentStatus.PENDING_RECEIVER_REGISTRATION
      return ComplimentStatus.PENDING_RECEIVER_CONFIRMATION
    when ComplimentStatus.ACTIVE
      return ComplimentStatus.ACTIVE
    else
      return ComplimentStatus.ACTIVE
    end
  end
  
  def update_sender_status(compliment_status)
    case compliment_status
    when ComplimentStatus.PENDING_RECEIVER_CONFIRMATION
      return ComplimentStatus.PENDING_RECEIVER_CONFIRMATION
    when ComplimentStatus.PENDING_RECEIVER_REGISTRATION
      return ComplimentStatus.PENDING_RECEIVER_REGISTRATION
    else
      return nil
    end
  end

  def confirmed?
    self.account_status.id == AccountStatus.CONFIRMED.id
  end

  # def self.search(search_string)
  #   return [] if search_string.blank?
  #   escaped_search_string = search_string.gsub(/%/, '\%').gsub(/_/, '\_')
  #   sa = search_string.downcase.split(' ')
  #   confirmed = AccountStatus.CONFIRMED
  #   search_array = []
  #   search_array << User.where('lower(first_name) in (?) AND lower(last_name) in (?) AND ' +
  #                              'lower(city) in (?) AND lower(email) in (?) AND account_status_id = ?',
  #                               sa, sa, sa, sa, confirmed)
  #   search_array << User.where('lower(first_name) in (?) AND lower(last_name) in (?) AND ' + 
  #                              'lower(city) in (?) AND account_status_id = ?', 
  #                               sa, sa, sa, confirmed)
  #   search_array << User.where('lower(first_name) in (?) AND lower(last_name) in (?) AND account_status_id = ?', 
  #                               sa, sa, confirmed)
  #   search_array << User.where('(lower(first_name) in (?) OR lower(last_name) in (?) OR ' +
  #                              'lower(city) in (?) OR lower(email) in (?)) AND account_status_id = ?',
  #                               sa, sa, sa, sa, confirmed)
  #   if search_array.length < 10
  #     sa.each do |s|
  #       term = "%#{s}%"
  #       search_array << User.where('(lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR ' +
  #                                  'lower(city) LIKE ? OR lower(email) LIKE ?) AND account_status_id = ?',
  #                                   term, term, term, term, confirmed)
  #     end
  #   end
  #   return search_array.flatten.uniq
  # end

  def self.user_cache
    Rails.cache.fetch("users") do
      User.select('first_name, last_name, email, city, domain, account_status_id').all
    end
  end

  def self.search_cache_with_domain(search_string, domain)
    a = Array.new(user_cache)
    return [] if search_string.blank? || a.blank?
    escaped_search_string = search_string.gsub(/%/, '\%').gsub(/_/, '\_')
    sa = escaped_search_string.downcase.split(' ')
    confirmed = AccountStatus.CONFIRMED.id

    if sa.length == 1
      puts sa[0]
      ra = Regexp.new(sa[0], true)
      puts ra
      a.keep_if{ |x| (x.first_name =~ ra || x.last_name =~ ra ||
                     x.email =~ ra || x.city =~ ra) && 
                     x.account_status_id == confirmed &&
                     (x.domain == domain || x.domain == Domain.master_domain) }
    elsif sa.length == 2
      ra = Regexp.new(sa[0], true)
      rb = Regexp.new(sa[1], true)
      a.keep_if{ |x| ((x.first_name =~ ra && x.last_name =~ rb) ||
                     (x.last_name =~ ra && x.first_name =~ rb) ||
                     (x.first_name =~ ra && x.city =~ rb) ||
                     (x.city =~ ra && x.first_name =~ rb) ||
                     (x.last_name =~ ra && x.city =~ rb) ||
                     (x.city =~ ra && x.last_name =~ rb) ||
                     (x.email =~ ra && x.city =~ rb) ||
                     (x.city =~ ra && x.email =~ rb)) &&
                     x.account_status_id == confirmed &&
                     (x.domain == domain || x.domain == Domain.master_domain) }
    end
    return a
  end

  def self.search_with_domain(search_string, domain)
    return [] if search_string.blank?
    escaped_search_string = search_string.gsub(/%/, '\%').gsub(/_/, '\_')
    sa = search_string.downcase.split(' ')
    confirmed = AccountStatus.CONFIRMED.id
    search_array = []
    if sa.length == 1
      term = "%#{sa[0]}%"
      search_array << User.where('(lower(first_name) like ? OR lower(last_name) like ? OR
                                  lower(email) like ? OR lower(city) like ?) AND 
                                  account_status_id = ? AND 
                                  (lower(domain) = ? OR lower(domain) = ?)',
                                  term, term, term, term, confirmed, domain, Domain.master_domain).limit(10)
    elsif sa.length == 2
      term1 = "%#{sa[0]}%"
      term2 = "%#{sa[1]}%"
      search_array << User.where('((lower(first_name) like ? AND lower(last_name) like ?) OR
                                  (lower(last_name) like ? AND lower(first_name) like ?) OR
                                  (lower(first_name) like ? AND lower(city) like ?) OR 
                                  (lower(city) like ? AND lower(first_name) like ?) OR 
                                  (lower(last_name) like ? AND lower(city) like ?) OR
                                  (lower(city) like ? AND lower(last_name) like ?) OR
                                  (lower(email) like ? AND lower(city) like ?) OR
                                  (lower(city) like ? AND lower(email) like ?)) AND
                                  account_status_id = ? AND
                                  (lower(domain) = ? OR lower(domain) = ?)',
                                  term1, term2, term1, term2, term1, term2, term1, term2,
                                  term1, term2, term1, term2, term1, term2, term1, term2,
                                  confirmed, domain, Domain.master_domain).limit(10)
    end
    return search_array.flatten.uniq
  end

  def self.search(search_string)
    return [] if search_string.blank?
    escaped_search_string = search_string.gsub(/%/, '\%').gsub(/_/, '\_')
    sa = search_string.downcase.split(' ')
    confirmed = AccountStatus.CONFIRMED.id
    search_array = []
    if sa.length == 1
      term = "%#{sa[0]}%"
      search_array << User.where('(lower(first_name) like ? OR lower(last_name) like ? OR
                                  lower(email) like ? OR lower(city) like ?) AND 
                                  account_status_id = ?',
                                  term, term, term, term, confirmed).limit(10)
    elsif sa.length == 2
      term1 = "%#{sa[0]}%"
      term2 = "%#{sa[1]}%"
      search_array << User.where('((lower(first_name) like ? AND lower(last_name) like ?) OR
                                  (lower(last_name) like ? AND lower(first_name) like ?) OR
                                  (lower(first_name) like ? AND lower(city) like ?) OR 
                                  (lower(city) like ? AND lower(first_name) like ?) OR 
                                  (lower(last_name) like ? AND lower(city) like ?) OR
                                  (lower(city) like ? AND lower(last_name) like ?) OR
                                  (lower(email) like ? AND lower(city) like ?) OR
                                  (lower(city) like ? AND lower(email) like ?)) AND
                                  account_status_id = ?',
                                  term1, term2, term1, term2, term1, term2, term1, term2,
                                  term1, term2, term1, term2, term1, term2, term1, term2,
                                  confirmed).limit(10)
    end
    return search_array.flatten.uniq
  end

  def self.search_compliment_receiver(search_string)
    return [] if search_string.blank?
    escaped_search_string = search_string.gsub(/%/, '\%').gsub(/_/, '\_')
    s = "%#{escaped_search_string}%"
    confirmed = AccountStatus.CONFIRMED
    search_array = []
    search_array << User.where('lower(first_name) LIKE ? OR ' +
                               'lower(last_name) LIKE ? OR ' +
                               'lower(city) LIKE ?OR ' + 
                               'lower(email) LIKE ?',
                               s, s, s, s).include(:photo)
    return search_array.flatten.uniq
  end

  def self.redis_search(search_string)
    return [] if search_string.blank?
    escaped_search_string = search_string.gsub(/%/, '\%').gsub(/_/, '\_')
    sa = escaped_search_string.downcase.split(' ')
    search_array = []
    users = $redis.hgetall redis_hash_name
    # puts sa
    sa.each do |search_term|
      # r = /search_term/
      puts users.count
      r = Regexp.new(search_term, true)
      puts r
      users.each do |k,v|
        d = user_document(v)
        # puts v
        # puts "#{v} - #{d}"
        # puts r =~ d
      end
      # users = users.keep_if { |k, v| !(r =~ user_document(v)).blank? }
      # puts users.count
    end
    return users
  end

  # v is a user_search_hash
  def self.user_document(v)
    puts "Is A Hash #{v.is_a?(Hash)}"
    puts "#{v.class} #{}"
    v = v.to_json
    puts v['first_name']
    # puts v['first_name']
    return "#{v['first_name']} #{v['last_name']} #{v['city']} #{v['email_addresses']}".downcase
  end

  def is_a_company?
    return !self.company.nil?
  end

  def is_company_administrator?(company_id)
    CompanyUser.administers_company?(self.id, company_id)
  end
  
  def metrics_send_new_user
    Metrics.new_user
  end

  def create_user_email
    logger.info("Create User Email: #{self.email}")
    UserEmail.create(:user_id => self.id, :email => self.email)
  end

  def self.valid_email?(email)
    return false if email.nil?
    return !email.match(@@email_regex_loc).nil?
  end

  def self.list_of_users_ordered_by_professional_compliments_sent(universe, amount=nil)
    list = User.joins("join compliments on compliments.sender_user_id = users.id")
               .select('count(compliments.id), users.*')
               .where('users.id in (?) and compliment_type_id in (?)', 
                       universe, ComplimentType.professional_send_ids)
               .group('users.id')
               .reorder('count(users.id) DESC')
    list = list.limit(amount) unless amount.blank?
    return list
  end

  def self.list_of_users_ordered_by_professional_compliments_received(universe, amount=nil)
    list = User.joins("join compliments on compliments.receiver_user_id = users.id")
               .select('count(compliments.id), users.*')
               .where('users.id in (?) and compliment_type_id in (?)', 
                       universe, ComplimentType.professional_receive_ids)
               .group('users.id')
               .reorder('count(users.id) DESC')
    list = list.limit(amount) unless amount.blank?
    return list
  end

  def add_to_redis
    if self.confirmed?
      email_list_string = self.email_addresses.collect{ |e| e.email }.join(' ')
      exists = $redis.exists redis_hash_name
      if exists
        $redis.del(self.redis_hash_name)
      end
      $redis.hmset(self.redis_hash_name, 'id', self.id,
                                         'first_name', self.first_name,
                                         'last_name', self.last_name,
                                         'city', self.city,
                                         'email_addresses', email_list_string)
    end
  end

  def user_search_hash
    email_list_string = self.email_addresses.collect{ |e| e.email }.join(' ')
    {
      'first_name' => self.first_name, 
      'last_name' => self.last_name, 
      'city' => self.city, 
      'email_addresses' => email_list_string
    }
  end

  def self.redis_user_set_name
    return "user_ids"
  end

  def redis_hash_name
    return "users:#{self.id}"
  end

  def redis_hash_values
    email_list_string = self.email_addresses.collect{ |e| e.email }.join(' ')
    {'first_name' => self.first_name,
     'last_name' => self.last_name,
     'city' => self.city,
     'email_addresses' => email_list_string}
  end

  def confirm_account
    update_attributes(:account_status => AccountStatus.CONFIRMED)
    self.primary_email.update_attributes(:confirmed => 'Y')
  end

  # Checking if self is a contact in user's groups
  def existing_contact?(user)
    return false if user.blank?
    self.existing_contacts(user).count > 0
  end

  # Return the groups where self is a contact in user's groups
  def existing_contacts(user)
    return false if user.blank?
    self.memberships.where('group_id in (?)', user.try(:groups))
  end

  def eligible_to_view_social?(target_user)
    logger.info("target_user id: #{target_user.id} self id: #{self.id}")
    return true if target_user.id.to_i == self.id
    # user must be in social group OR group must be visible to social OR social group must be public
    target_social_group = Group.get_social_group(target_user)
    return true if target_social_group.has_public_visibility?
    contacts = target_social_group.contacts
    contact_ids = contacts.collect{|c| c.id.to_i}
    return contact_ids.include?(self.id.to_i)
  end

  def eligible_to_view_professional?(target_user)
    return true if target_user.id == self.id
    # user must be in professional group OR group must be visible to professional OR pro group must be public
    target_professional_group = Group.get_professional_group(target_user)
    return true if target_professional_group.has_public_visibility?
    contacts = target_professional_group.contacts
    contact_ids = contacts.collect{|c| c.id.to_i}
    return contact_ids.include?(self.id.to_i)
  end

  private
    def encrypt(password)
      BCrypt::Engine.hash_secret(password, self.salt)
    end
    
end
