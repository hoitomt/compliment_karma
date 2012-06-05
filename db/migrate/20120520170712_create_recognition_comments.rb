class CreateRecognitionComments < ActiveRecord::Migration
  def change
    create_table :recognition_comments do |t|
      t.integer :recognition_id
      t.integer :recognition_type_id
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
  end
end
