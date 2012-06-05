class CreateUserAccomplishments < ActiveRecord::Migration
  def change
    create_table :user_accomplishments do |t|
      t.integer :user_id
      t.integer :accomplishment_id

      t.timestamps
    end
  end
end
