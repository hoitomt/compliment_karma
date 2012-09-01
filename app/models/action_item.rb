class ActionItem < ActiveRecord::Base
	belongs_to :action_item_type
	belongs_to :user
	belongs_to :originating_user, :class_name => "User", :foreign_key => 'originating_user_id'

	default_scope :order => 'created_at desc'
end
