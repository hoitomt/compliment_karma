class AddNewEmailConfirmationTokenToUserEmails < ActiveRecord::Migration
  def change
    add_column :user_emails, :new_email_confirmation_token, :string
  end
end
