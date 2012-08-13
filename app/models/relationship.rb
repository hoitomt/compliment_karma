class Relationship < ActiveRecord::Base
  belongs_to :relationship_status
  belongs_to :visibility, :foreign_key => 'default_visibility_id'
  
  validates :user_1_id, :presence => true,
                        :uniqueness => { :scope => :user_2_id }

  validates :user_2_id, :presence => true,
                        :uniqueness => { :scope => :user_1_id }

  validate :relationship_does_not_exist, :on => :create
  validate :relationship_is_not_with_self
  
  before_create :set_relationship_status
  before_create :set_visibility
  
  def set_relationship_status
    if self.relationship_status.blank?
      if User.is_internal?(self.user_1_id, self.user_2_id)
        self.relationship_status = RelationshipStatus.ACCEPTED 
      else
        self.relationship_status = RelationshipStatus.PENDING
      end
    end
  end
  
  def set_visibility
    if self.visibility.blank?
      if User.is_internal?(self.user_1_id, self.user_2_id)
        self.visibility = Visibility.EVERYBODY
      else
        self.visibility = Visibility.SENDER_AND_RECEIVER
      end
    end
  end
  
  def is_internal?
  end

  def accepted?
    self.relationship_status == RelationshipStatus.ACCEPTED
  end
  
  def relationship_does_not_exist
    r = Relationship.where('(user_1_id = ? AND user_2_id = ?) OR (user_1_id = ? AND user_2_id = ?)',
                            self.user_1_id, self.user_2_id, self.user_2_id, self.user_1_id)
    if r && r.any?
      errors.add(:user_1_id, "Specified relationship already exists")
    end
  end
  
  def relationship_is_not_with_self
    if self.user_1_id == self.user_2_id
      errors.add(:user_1_id, "Specified relationship must not be with self")
    end
  end
  
  def accept_relationship
    self.update_attributes(:relationship_status_id => RelationshipStatus.ACCEPTED.id,
                           :default_visibility_id => Visibility.EVERYBODY.id)
    UpdateHistory.Accepted_Compliments_Receiver(self)
  end
  
  def decline_relationship
    self.update_attributes(:relationship_status_id => RelationshipStatus.NOT_ACCEPTED.id,
                           :default_visibility_id => Visibility.SENDER_AND_RECEIVER.id)
    UpdateHistory.Rejected_Compliment_Receiver(self)
  end
  
  def self.get_relationship(user_1, user_2)
    return nil if user_1.nil? || user_2.nil?
    r = Relationship.where('(user_1_id = ? AND user_2_id = ?) OR (user_1_id = ? AND user_2_id = ?)',
                            user_1.id, user_2.id, user_2.id, user_1.id)
    return r[0] #if r.length == 1
  end

  def self.accepted_relationship?(user_1, user_2)
    r = get_relationship(user_1, user_2)
    return !r.blank? && r.relationship_status == RelationshipStatus.ACCEPTED
  end
  
  def self.get_pending_relationships(user)
    return nil if user.nil?
    # Only concerned with user 2 because that is the user that needs to confirm the relationship
    r = Relationship.where('user_2_id = ? AND relationship_status_id = ?',
                            user.id, RelationshipStatus.PENDING)
  end
  
  # Returns all ACCEPTED relationships for user
  def self.all_accepted_contacts(user)
    Relationship.where("(user_1_id = ? OR user_2_id = ?) AND relationship_status_id = ?",
                   user.id, user.id, RelationshipStatus.ACCEPTED.id)
  end
  
  # Returns a hash of users that have a relationship with the user
  # and the domain matches the user domain
  def self.all_internal_contacts(user)
    relationships = all_accepted_contacts(user)
    internal_contacts = {}
    relationships.each do |relationship|
      user_1 = User.find(relationship.user_1_id)
      user_2 = User.find(relationship.user_2_id)
      internal_contacts[user_1.id] = user_1 if user_1.domain == user.domain
      internal_contacts[user_2.id] = user_2 if user_2.domain == user.domain
    end
    return internal_contacts
  end
  
  # Returns a hash of users that have a relationship with the user
  # and the domain does not match the user domain
  def self.all_external_contacts(user)
    relationships = all_accepted_contacts(user)
    external_contacts = {}
    relationships.each do |relationship|
      user_1 = User.find(relationship.user_1_id)
      user_2 = User.find(relationship.user_2_id)
      external_contacts[user_1.id] = user_1 if user_1.domain != user.domain
      external_contacts[user_2.id] = user_2 if user_2.domain != user.domain
    end
    return external_contacts
  end
  
end
