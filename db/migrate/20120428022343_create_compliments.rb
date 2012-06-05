class CreateCompliments < ActiveRecord::Migration
  def change
    create_table :compliments do |t|
      t.string :skill
      t.string :sender_email
      t.string :receiver_email
      t.integer :sender_user_id
      t.integer :receiver_user_id
      t.text :comment
      t.integer :relation_id

      t.timestamps
    end
  end
end
