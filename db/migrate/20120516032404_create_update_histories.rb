class CreateUpdateHistories < ActiveRecord::Migration
  def change
    create_table :update_histories do |t|
      t.integer :user_id
      t.text :note

      t.timestamps
    end
  end
end
