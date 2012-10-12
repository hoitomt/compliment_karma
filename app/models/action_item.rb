class ActionItem < ActiveRecord::Base
	belongs_to :action_item_type
	belongs_to :user
	belongs_to :originating_user, :class_name => "User", :foreign_key => 'originating_user_id'

	default_scope :order => 'created_at desc'

	def complete?
		return self.complete == "Y"
	end

	def set_complete
		update_attributes(:complete => "Y")
	end

	def self.incomplete_for_user(user=nil)
		return nil if user.blank?
		ActionItem.where('user_id = ? and complete <> ?', user.id, 'Y')
	end

	def self.create_from_compliment(compliment)
		return if compliment.blank? || compliment.receiver.blank? ||
							receiver_is_an_accepted_contact?(compliment)
		create(:user_id => compliment.receiver.id,
           :recognition_type_id => RecognitionType.COMPLIMENT.id,
           :recognition_id => compliment.id,
           :action_item_type_id => ActionItemType.Authorize_Contact.id,
           :originating_user_id => compliment.sender.id )
  end

  def self.retrieve_from_compliment(compliment)
  	return nil if compliment.blank?
  	ActionItem.where(:recognition_type_id => RecognitionType.COMPLIMENT,
  									 :recognition_id => compliment.id,
  									 :complete => 'N').first
  end

  def self.receiver_is_an_accepted_contact?(compliment)
  	contacts = compliment.sender.existing_contacts(compliment.receiver)
  	logger.info("Compliment Receiver: #{compliment.receiver.primary_email.email}")
  	c = contacts.collect{|x| x.group.name }
  	logger.info("New Action Item from compliment Contacts: #{c}")
  	if contacts.length > 0
  		contacts.each do |c|
  			return false if c.group.declined?
  		end
  		return true
		else
			return false
		end
  end

  def send_accept_notification
    UpdateHistory.Accepted_Compliment_Receiver(self)
  end

  def send_decline_notification
    UpdateHistory.Rejected_Compliment_Receiver(self)
  end

end
