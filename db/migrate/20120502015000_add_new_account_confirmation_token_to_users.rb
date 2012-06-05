class AddNewAccountConfirmationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :new_account_confirmation_token, :string
  end
end
