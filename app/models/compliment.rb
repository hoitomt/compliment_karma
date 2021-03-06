class Compliment < ActiveRecord::Base
  belongs_to :relation
  belongs_to :compliment_status
  belongs_to :visibility
  belongs_to :compliment_type
  belongs_to :skill

  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_user_id'
  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_user_id'

  has_many :tags, :foreign_key => :recognition_id,
                  :conditions => {:recognition_type_id => RecognitionType.COMPLIMENT ? RecognitionType.COMPLIMENT.id : nil},
                  :dependent => :delete_all
  has_one :recognition, :foreign_key => :recognition_id,
                  :conditions => {:recognition_type_id => RecognitionType.COMPLIMENT ? RecognitionType.COMPLIMENT.id : nil},
                  :dependent => :destroy
  has_many :groups, :through => :tags,
                    :dependent => :delete_all

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :receiver_display, :new_contact_created, :suppress_fulfillment # for seeding data only

  validates :receiver_email, :presence => true,
                             :format => { :with => email_regex }

  validates :sender_email, :presence => true,
                           :format => { :with => email_regex }

  validates :skill_id, :presence => true

  validates :comment, :presence => true,
                      :length => {:within => 2..140, :message => "Too short"}

  validates :compliment_type_id, :presence => true

  validate :compliment_cannot_be_to_self
  validate :sender_is_confirmed_user
  validate :not_short_term_duplicate, :on => :create

  before_save :set_sender
  before_save :parse_sender_domain
  before_save :parse_receiver_domain
  before_save :set_sender_user_id
  before_save :set_receiver_user_id
  before_save :remove_naughty_words
  before_create :set_compliment_status
  before_create :set_visibility
  after_create :set_relationship
  after_create :create_action_item
  after_create :send_fulfillment
  after_create :update_history
  after_create :create_tags
  after_create :add_accomplishment
  after_create :create_contact
  after_create :create_recognition

  default_scope :order => "created_at DESC"


  def create_from_api(recipient_email, params)
    sender_email = clean_email_address(params['from']) if params['from']
    user = User.find_user_by_email(sender_email)
    if user.blank?
      Compliment.notify_ck_unrecognized_sender(params)
      Compliment.notify_sender_unrecognized_sender(params, sender_email)
      return
    elsif !user.confirmed?
      user.account_confirmation_token
      Compliment.notify_sender_unconfirmed_sender(params, user)
      return
    end
    self.sender_user_id = user.id
    self.sender_email = sender_email
    self.receiver_email = clean_email_address(recipient_email)
    receiver = User.find_user_by_email(self.receiver_email)
    self.receiver = receiver
    logger.info("Receiver Email: #{self.receiver_email}")
    self.skill_id = api_skill(params['body-plain']).id
    self.comment = api_comment(params['stripped-text'])
    self.compliment_type_id = ComplimentType.auto_assign(self)
    if self.save
      return true
    else
      logger.info(self.errors.messages)
      return false
    end

  end

  def clean_email_address(email)
    combo = email.scan(/<.*>/)
    email = combo[0].gsub(/<|>/, '') unless email.blank? || combo.blank?
    return email
  end

  def api_skill(body)
    body_regex = /\^[^\^]*\^/
    dirty_skill = body.match(body_regex) { |m| m[0] } if body
    skill = dirty_skill.gsub(/\\n|\\t|\^/, '').strip if dirty_skill
    logger.info "Skill: #{skill}"
    if Skill.matches_compliment_type?(skill) || skill.blank?
      self.compliment_status = ComplimentStatus.MISSING_INFORMATION
      Compliment.notify_sender_unknown_skill(sender, self)
      return Skill.UNDEFINED
    else
      return Skill.find_or_create_skill(nil, skill)
    end
  end

  def api_comment(stripped_body)
    # strip the greeting
    stripped_body.gsub!(/.*(,|:|;|-)[\r\n]+/, '')
    stripped_body.gsub!(/\^/, '')
    return stripped_body.strip[0..139]
  end

  def api_compliment_type_id
  end

  def self.notify_ck_unrecognized_sender(params)
    ComplimentMailer.notify_ck_unrecognized_sender(params).deliver
  end

  def self.notify_sender_unrecognized_sender(params, sender_email)
    ComplimentMailer.notify_sender_unrecognized_sender(params, sender_email)
  end

  def self.notify_sender_unconfirmed_sender(params, sender)
    ComplimentMailer.notify_sender_unconfirmed_sender(params, sender)
  end

  def self.notify_sender_unknown_skill(sender, compliment)
    ComplimentMailer.notify_sender_unknown_skill(sender, compliment)
  end

  # return the compliments that are pending for an email address
  # intent is to notify a potential user that there are compliments waiting for them
  def self.get_pending_compliments(receiver_email)
    pending = Compliment.where("receiver_email = ? AND receiver_user_id is null", receiver_email)
  end

  def compliment_cannot_be_to_self
    if(self.sender_email == self.receiver_email)
      errors.add(:receiver_email,
                  "We think you are wonderful too but you cannot compliment yourself")
    end
  end

  def sender_is_confirmed_user
    user = User.find_user_by_email(self.sender_email)
    if(!user || !user.confirmed?)
      errors.add(:sender_email, "Please confirm your account prior to complimenting")
    end
  end

  def not_short_term_duplicate
    t = DateTime.now - 1.minute
    c = Compliment.where('(sender_email = ? OR sender_user_id = ?) AND
                          (receiver_email = ? OR receiver_user_id = ?) AND
                          skill_id = ? AND comment = ? AND compliment_type_id = ? AND
                          created_at > ?',
                          self.sender_email, self.sender_user_id,
                          self.receiver_email, self.receiver_user_id,
                          self.skill_id, self.comment, self.compliment_type_id, t)
    unless c.blank?
      errors.add(:comment, "Duplicate compliment with recent compliment")
    end
  end

  def send_fulfillment
    return if suppress_fulfillment
    begin
      set_compliment_status if self.compliment_status.nil?
      case self.compliment_status
      when ComplimentStatus.ACTIVE
        ComplimentMailer.send_compliment(self).deliver
      when ComplimentStatus.PENDING_RECEIVER_CONFIRMATION
        ComplimentMailer.receiver_confirmation_reminder(self).deliver
      when ComplimentStatus.PENDING_RECEIVER_REGISTRATION
        ComplimentMailer.receiver_registration_invitation(self).deliver
      else
        # Do Nothing
      end
    rescue SocketError => e
      logger.info("Sending email to #{self.receiver_email}\n#{e.message}")
    end
  end

  def set_sender
    if self.sender_email.nil?
      self.sender_email = current_user.email
    end
  end

  # If both the sender and receiver have user_ids, create a relationship
  def set_relationship
    if self.compliment_status == ComplimentStatus.ACTIVE ||
       self.compliment_status == ComplimentStatus.PENDING_RECEIVER_CONFIRMATION
      sender = User.find_user_by_email(self.sender_email)
      receiver = User.find_user_by_email(self.receiver_email)
      new_relationship_status = RelationshipStatus.PENDING
      # Coworkers
      new_relationship_status = RelationshipStatus.ACCEPTED if sender.domain == receiver.domain
      # Previously Accepted
      relationship = Relationship.get_relationship(sender, receiver)
      if relationship.nil? || relationship.blank?
        Relationship.create(:user_1_id => sender.id,
                            :user_2_id => receiver.id,
                            :relationship_status_id => new_relationship_status.id)
      end
    end
  end

  def create_action_item
    if !self.sender.existing_contact?(self.receiver)
      logger.info("Create Action Item")
      ActionItem.create_from_compliment(self)
    end
  end

  def create_contact
    logger.info("Create Contact")
    if !self.receiver.blank? &&
       !self.receiver.existing_contact?(self.sender)
      logger.info("Not Existing")
      c = Contact.create_from_compliment(self)
      self.new_contact_created = true if !c.blank? && c.valid?
    end
  end

  def create_recognition
    Recognition.create_from_compliment(self)
  end

  def set_compliment_status
    if receiver_status == AccountStatus.CONFIRMED
      logger.info("Set Compliment Status - Active")
      self.compliment_status = ComplimentStatus.ACTIVE
    elsif receiver_status == AccountStatus.UNCONFIRMED
      logger.info("Set Compliment Status - Pending Receiver Confirmation")
      self.compliment_status = ComplimentStatus.PENDING_RECEIVER_CONFIRMATION
    else
      logger.info("Set Compliment Status - Pending Receiver Registration")
      self.compliment_status = ComplimentStatus.PENDING_RECEIVER_REGISTRATION
    end
  end

  def sender_status
    return User.get_account_status(self.sender_email)
  end

  def receiver_status
    return User.get_account_status(self.receiver_email)
  end

  def parse_sender_domain
    d = self.sender_email.split('@')
    self.sender_domain = d[1] if d.size > 1
  end

  def parse_receiver_domain
    d = self.receiver_email.split('@')
    self.receiver_domain = d[1] if d.size > 1
  end

  def set_sender_user_id
    u = User.find_user_by_email(self.sender_email)
    self.sender_user_id = u.id if u
  end

  def set_receiver_user_id
    u = User.find_user_by_email(self.receiver_email)
    self.receiver_user_id = u.id if u
  end

  def remove_naughty_words
    self.comment = Blacklist.clean_string(self.comment)
  end

  def decline
    logger.info("Decline Compliment")
    self.compliment_status = ComplimentStatus.DECLINED
    self.save!
  end

  def self.user_confirmation(user)
    logger.info("Confirm account for #{user.first_last if user}")
    Compliment.where('receiver_user_id = ? AND
                          (compliment_status_id = ? OR compliment_status_id = ?)',
                          user.id, ComplimentStatus.PENDING_RECEIVER_CONFIRMATION,
                          ComplimentStatus.PENDING_RECEIVER_REGISTRATION)
                  .update_all(:compliment_status_id => ComplimentStatus.ACTIVE.id)
    # c.each do |compliment|
    #   compliment.update_attributes()
    # end
  end

  def self.update_receiver_user_id(user_id, email)
    Compliment.where(:receiver_email => email)
              .update_all(:receiver_user_id => user_id)
  end

  def set_visibility
    if self.visibility_id.blank?
      # Set this for now
      self.visibility = Visibility.EVERYBODY

      # # Look up the visibility from the relationship
      # receiver = User.find_by_id(self.receiver_user_id)
      # sender = User.find_by_id(self.sender_user_id)
      # relationship = Relationship.get_relationship(sender, receiver)
      # if relationship
      #   self.visibility = relationship.visibility
      # end

      # if self.visibility.nil?
      #   if self.sender_domain == self.receiver_domain
      #     self.visibility = Visibility.EVERYBODY
      #   else
      #     self.visibility = Visibility.SENDER_AND_RECEIVER
      #   end
      # end
    end
  end

  def create_tags
    create_sender_tag
    create_receiver_tag
  end

  def add_accomplishment
    sender = self.sender
    case sender.compliments_sent.count
    when 1
      Accomplishment.add_accomplishment(self.sender, Accomplishment.LEVEL_1_COMPLIMENTER.id)
    when 50
      Accomplishment.add_accomplishment(self.sender, Accomplishment.LEVEL_2_COMPLIMENTER.id)
    when 200
      Accomplishment.add_accomplishment(self.sender, Accomplishment.LEVEL_3_COMPLIMENTER.id)
    when 500
      Accomplishment.add_accomplishment(self.sender, Accomplishment.LEVEL_4_COMPLIMENTER.id)
    when 1000
      Accomplishment.add_accomplishment(self.sender, Accomplishment.LEVEL_5_COMPLIMENTER.id)
    end
  end

  def create_sender_tag
    sender_group = Group.get_sender_group_by_compliment_type(self.compliment_type, self.sender)
    Tag.create_from_compliment(self, sender_group)
  end

  def create_receiver_tag
    return if self.receiver_user_id.blank?
    receiver_group = Group.get_receiver_group_by_compliment_type(self.compliment_type, self.receiver)
    Tag.create_from_compliment(self, receiver_group)
  end

  def get_sender
    User.find(self.sender_user_id) unless self.sender_user_id.blank?
  end

  def get_receiver
    User.find(self.receiver_user_id) unless self.receiver_user_id.blank?
  end

  def update_history
    UpdateHistory.Received_Compliment(self)
  end

  def receiver_name
    self.receiver_user_id.blank? ? "New User" : self.receiver.first_last
  end

  def self.compliment_by_relation_item_type(user, relation_item_type_id=nil)
    if relation_item_type_id
      case relation_item_type_id.to_i
      when RelationItemType.ONLY_MINE.id
        return Compliment.only_mine(user)
      when RelationItemType.INTERNAL_COWORKERS.id
        return Compliment.internal_coworkers(user)
      when RelationItemType.EXTERNAL_COLLEAGUES.id
        return Compliment.external_colleagues
      when RelationItemType.ALL_PROFESSIONAL_CONTACTS.id
        return Compliment.all_professional_contacts(user)
      end
    else
      return Compliment.all_compliments_from_followed(user)
      # return Compliment.all_compliments(user)
    end
  end

  def self.all_compliments(user)
    logger.info("Compliments: All")
    Compliment.where('sender_email = ? OR receiver_email = ?',
                     user.email, user.email)
  end

  def self.all_compliments_from_followed(user)
    logger.info("Compliments from everybody user is following")
    followed = Follow.find_all_by_follower_user_id(user.id)
    list_of_compliments = []
    followed.each do |follow|
      list_of_compliments += all_active_compliments(follow.subject_user)
    end
    logger.info("Count of Compliments: " + list_of_compliments.count.to_s)
    return list_of_compliments
  end

  def self.all_compliments_from_followed_in_domain(user)
    logger.info("Compliments from everybody user is following")
    followed = Follow.find_all_by_follower_user_id(user.id)
    list_of_compliments = []
    followed.each do |follow|
      if user.domain == Domain.master_domain
        list_of_compliments += all_active_compliments_in_domain(follow.subject_user, user)
      elsif [user.domain, Domain.master_domain].include?(follow.subject_user.domain)
        list_of_compliments += all_active_compliments_in_domain(follow.subject_user, user)
      end
    end
    logger.info("Count of Compliments: " + list_of_compliments.count.to_s)
    return list_of_compliments
  end

  def self.all_compliments_from_followed_and_self(user)
    logger.info("Compliments from everybody user is following and the user")
    followed = Follow.find_all_by_follower_user_id(user.id)
    list_of_compliments = all_active_compliments(user)
    followed.each do |follow|
      list_of_compliments += all_active_compliments(follow.subject_user)
    end
    logger.info("Count of Compliments: " + list_of_compliments.count.to_s)
    return list_of_compliments
  end

  def self.all_active_compliments(user)
    logger.info("Active Compliments")
    Compliment.where('(sender_user_id = ? OR receiver_user_id = ?) ' +
                     'AND compliment_status_id = ? AND visibility_id = ?',
                     user.id, user.id, ComplimentStatus.ACTIVE.id, Visibility.EVERYBODY.id)
  end

  def self.all_active_compliments_in_domain(user, visitor)
    logger.info("Active Compliments")
    if visitor.domain == Domain.master_domain
      Compliment.where('(sender_user_id = ? OR receiver_user_id = ?)
                       AND compliment_status_id = ? AND visibility_id = ?',
                       user.id, user.id, ComplimentStatus.ACTIVE.id, Visibility.EVERYBODY.id)
    else
      domains = [visitor.domain, Domain.master_domain]
      Compliment.where('( (sender_user_id = ? AND receiver_domain in (?)) OR
                          (receiver_user_id = ? AND sender_domain in (?)) )
                       AND compliment_status_id = ? AND visibility_id = ?',
                       user.id, domains, user.id, domains,
                       ComplimentStatus.ACTIVE.id, Visibility.EVERYBODY.id)
    end
  end

  # Sandbox for attempting to reduce the number of queries
  def self.all_active_compliments_optimize(user_id)
    type_id = RecognitionType.COMPLIMENT.id
    Compliment.order(:created_at).
              # select("compliments.*").
              select("compliments.*, count(ck_likes.id) as likes_count").
              joins("left outer join ck_likes on (recognition_id = compliments.id AND
                                                   recognition_type_id = #{type_id})").
              where('(sender_user_id = ? OR receiver_user_id = ?)
                     AND compliment_status_id = ? AND visibility_id = ?',
                     user_id, user_id, ComplimentStatus.ACTIVE.id, Visibility.EVERYBODY.id).
              group("compliments.id")
  end

  def self.all_active_compliments_by_email(user)
    logger.info("Active Compliments")
    Compliment.where('(sender_email = ? OR receiver_email = ?) ' +
                     'AND compliment_status_id = ? AND visibility_id = ?',
                     user.email, user.email, ComplimentStatus.ACTIVE.id, Visibility.EVERYBODY.id)
  end

  def self.karma_activity_list(visitor, page_owner)
    logger.info("Visitor: #{visitor.first_last if visitor} -> " +
                "Page Owner #{page_owner.first_last if page_owner}")
    compliment_type_id = RecognitionType.COMPLIMENT.id
    active_compliment_id = ComplimentStatus.ACTIVE.id
    public_group = Group.get_public_group(page_owner)
    membership_group_ids = visitor.memberships.select(:group_id).uniq.collect{|x| x.group_id} if visitor
    logger.info("Visitor Memberships: #{membership_group_ids}")
    if visitor && visitor.id == page_owner.id
      logger.info("Viewing your own page")
      followed_user_ids = page_owner.followed_users.select(:subject_user_id).uniq.collect{|x| x.subject_user_id}
      sql = "SELECT distinct(c.*) from compliments c
             JOIN tags t on (t.recognition_type_id = ? AND t.recognition_id = c.id)
             JOIN groups g on g.id = t.group_id AND g.user_id in (?)
             JOIN group_relationships gr on gr.sub_group_id = g.id
             WHERE (c.sender_user_id in (?) OR c.receiver_user_id in (?))
             AND c.compliment_status_id = ?
             AND (gr.super_group_id in (?) OR
                      (select count(1)
                       from group_relationships grx, groups gx
                       where grx.super_group_id = gx.id
                       and grx.sub_group_id = g.id
                       and gx.name = 'Public') > 0)"
      compliments = find_by_sql([sql, compliment_type_id, followed_user_ids, followed_user_ids,
                                     followed_user_ids, active_compliment_id, membership_group_ids])
    else
      logger.info("Visiting someone's page")
      sql = "SELECT distinct(c.*) FROM compliments c
             JOIN tags t ON (t.recognition_type_id = ? AND t.recognition_id = c.id)
             JOIN groups g ON g.id = t.group_id AND g.user_id = ?
             JOIN group_relationships gr ON gr.sub_group_id = g.id
             WHERE (c.sender_user_id = ? OR c.receiver_user_id = ?)
             and c.compliment_status_id = ?
             AND (gr.super_group_id in (?) OR
                      (select count(1)
                       from group_relationships grx, groups gx
                       where grx.super_group_id = gx.id
                       and grx.sub_group_id = g.id
                       and gx.name = 'Public') > 0)"
      compliments = find_by_sql([sql, compliment_type_id, page_owner.id,
                                      page_owner.id, page_owner.id,
                                      active_compliment_id, membership_group_ids])
    end
    return compliments
  end

  def self.only_mine(user)
    logger.info("Compliments: Only Mine")
    v = [Visibility.SENDER_AND_RECEIVER.id,
         Visibility.EVERYBODY.id,
         Visibility.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_THIS_JOB.id,
         Visibility.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_ALL_JOBS.id]
    Compliment.where('(sender_user_id = ? AND visibility_id in (?) ) OR ' +
                     '(receiver_user_id = ? and visibility_id in (?) )',
                     user.id, Visibility.all_visibility_ids, user.id, v)
  end

  def self.internal_coworkers(user)
    logger.info("Compliments: Internal Coworkers")
    internal_relationships = Relationship.all_internal_contacts(user)
    v = [Visibility.EVERYBODY.id,
         Visibility.COWORKERS_FROM_THIS_JOB.id,
         Visibility.COWORKERS_FROM_ALL_JOBS.id,
         Visibility.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_THIS_JOB.id,
         Visibility.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_ALL_JOBS.id]
    Compliment.where('(sender_user_id in (?) OR receiver_user_id in (?)) AND visibility_id in (?)',
                    internal_relationships.keys, internal_relationships.keys, v)
  end

  def self.external_colleagues(user)
    logger.info("Compliments: External")
    external_relationships = Relationship.all_external_contacts(user)
    sender_v = [Visibility.COWORKERS_FROM_THIS_JOB.id,
                Visibility.COWORKERS_FROM_ALL_JOBS.id,
                Visibility.EVERYBODY.id,
                Visibility.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_THIS_JOB.id,
                Visibility.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_ALL_JOBS.id]
    receiver_v = [Visibility.EVERYBODY.id,
                  Visibility.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_THIS_JOB.id,
                  Visibility.COWORKERS_AND_EXTERNAL_CONTACTS_FROM_ALL_JOBS.id]
    Compliment.where('(sender_user_id in (?) AND visibility_id in (?)) '+
                     'OR (receiver_user_id in (?) AND visibility_id in (?))',
                     external_relationships.keys, sender_v, external_relationships.keys, receiver_v)
  end

  def self.get_compliments_by_relationship(relationship)
    logger.info("Compliments: Get by Relationship")
    c = Compliment.where('(sender_user_id = ? AND receiver_user_id = ?) OR ' +
                     '(sender_user_id = ? and receiver_user_id = ?)',
                     relationship.user_1_id, relationship.user_2_id,
                     relationship.user_2_id, relationship.user_1_id)
  end

  def self.get_compliments_since_monday(user)
    logger.info("Compliments: This week")
    d = DateUtil.get_previous_monday_at_zero_time
    c = Compliment.where('created_at >= ? AND sender_user_id = ?', d, user.id)
  end

  def self.sent_professional_compliments(user)
    logger.info("Sent Professional")
    types = ComplimentType.professional_send_ids
    status_id = ComplimentStatus.ACTIVE.id
    Compliment.where('sender_user_id = ? AND
                      compliment_type_id in (?) AND
                      compliment_status_id = ?',
                      user.id, types, status_id)
  end

  def self.sent_social_compliments(user)
    logger.info("Sent Social")
    types = ComplimentType.social_send_ids
    status_id = ComplimentStatus.ACTIVE.id
    Compliment.where('sender_user_id = ? AND
                      compliment_type_id in (?) AND
                      compliment_status_id = ?',
                      user.id, types, status_id)
  end

  def self.received_professional_compliments(user)
    logger.info("Received Professional")
    types = ComplimentType.professional_receive_ids
    status_id = ComplimentStatus.ACTIVE.id
    Compliment.where('receiver_user_id = ? AND
                      compliment_type_id in (?) AND
                      compliment_status_id = ?',
                      user.id, types, status_id)
  end

  def self.received_social_compliments(user)
    logger.info("Received Social")
    types = ComplimentType.social_receive_ids
    status_id = ComplimentStatus.ACTIVE.id
    Compliment.where('receiver_user_id = ? AND
                      compliment_type_id in (?) AND
                      compliment_status_id = ?',
                      user.id, types, status_id)
  end

  def metrics_send_new_compliment
    Metrics.new_compliment
  end

  def self.first_compliment?(sender, receiver)
    return true if sender.blank? || receiver.blank?
    c = Compliment.where('sender_user_id = ? and receiver_user_id = ?',
                          sender.id, receiver.id).count
    return c == 1
  end

  def get_sender_group_from_compliment_type
    if self.compliment_type.professional_sender?
      return Group.get_professional_group(self.sender)
    else
      return Group.get_social_group(self.sender)
    end
  end

  def get_receiver_group_from_compliment_type
    if self.compliment_type.professional_receiver?
      return Group.get_professional_group(self.receiver)
    else
      return Group.get_social_group(self.receiver)
    end
  end

end
