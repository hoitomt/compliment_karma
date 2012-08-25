class CreateUserEmails < ActiveRecord::Migration
  def change
    create_table :user_emails do |t|
      t.integer :user_id
      t.string :email
      t.string :domain
      t.string :confirmed
      t.string :primary

      t.timestamps
    end
  end
end
