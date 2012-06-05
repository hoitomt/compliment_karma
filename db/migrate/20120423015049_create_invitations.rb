class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :invite_email
      t.string :from_email

      t.timestamps
    end
  end
end
