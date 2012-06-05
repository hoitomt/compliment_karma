class CreateCkLikes < ActiveRecord::Migration
  def change
    create_table :ck_likes do |t|
      t.integer :recognition_id
      t.integer :recognition_type_id
      t.integer :user_id

      t.timestamps
    end
  end
end
