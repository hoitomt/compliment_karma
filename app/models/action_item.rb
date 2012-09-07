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

end
