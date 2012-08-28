class RenamePrimaryToPrimaryEmail < ActiveRecord::Migration
  def up
  	rename_column :user_emails, :primary, :primary_email
  end

  def down
  	rename_column :user_emails, :primary_email, :primary
  end
end
