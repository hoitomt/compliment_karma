class AddOriginatingUserIdToActionItems < ActiveRecord::Migration
  def change
    add_column :action_items, :originating_user_id, :integer
    add_column :action_items, :note, :text
  end
end
