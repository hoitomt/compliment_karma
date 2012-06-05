class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_1_id
      t.integer :user_2_id
      t.integer :status_id

      t.timestamps
    end
  end
end
