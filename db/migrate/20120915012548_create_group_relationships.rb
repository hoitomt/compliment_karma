class CreateGroupRelationships < ActiveRecord::Migration
  def change
    create_table :group_relationships do |t|
      t.integer :sub_group_id
      t.integer :super_group_id

      t.timestamps
    end
  end
end
