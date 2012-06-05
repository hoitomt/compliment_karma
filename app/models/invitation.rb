class Invitation < ActiveRecord::Base
  attr_accessible :invite_email, :from_email
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :invite_email, :presence => true,
                           :format => { :with => email_regex }
  validates :from_email, :presence => true,
                         :format => { :with => email_regex }
  validate :invite_email_should_not_equal_from_email
  
  def invite_email_should_not_equal_from_email
    errors.add(:from_email, "The invitation must not be from the sender") unless
      !self.from_email.blank? && 
      !self.invite_email.blank? &&
      self.from_email != self.invite_email
  end
                         
  def send_invitation
    logger.info("Invitation sent to #{self.invite_email}")
    InvitationMailer.send_invitation(self).deliver
    # don't invite a current member to re-join
    # u = User.find_by_email(self.invite_email)
    # if u.nil?
    # end
  end
  
  def self.create_invitation(to, from)
    logger.info("create_invitation to #{to} from #{from}")
    time_frame = 0.25
    if no_recent_invitation?(to, time_frame)
      invite = Invitation.create(:invite_email => to, :from_email => from) 
      invite.send_invitation
      return true
    else
      logger.info("Recent invitation found within the last #{(0.25 * 60).to_i} minutes")
      return false
    end
  end
  
  def self.no_recent_invitation?(email, time_gap_hours)
    start_time = Time.now - time_gap_hours.hours
    end_time = Time.now
    invitation = Invitation.where('invite_email = ? AND created_at > ? AND created_at < ?',
                                  email, start_time, end_time)
    return invitation.nil? || invitation.empty?
  end
  
end
