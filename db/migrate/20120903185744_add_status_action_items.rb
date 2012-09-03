class AddStatusActionItems < ActiveRecord::Migration
  def change
  	add_column :action_items, :complete, :string, :default => 'N'
  end
end
