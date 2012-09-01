class CreateActionItems < ActiveRecord::Migration
  def change
    create_table :action_items do |t|
      t.integer :user_id
      t.integer :recognition_type_id
      t.integer :recognition_id
      t.integer :action_item_type_id

      t.timestamps
    end
  end
end
