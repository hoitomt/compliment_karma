class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :register_ip, :string
    add_column :users, :account_status_id, :integer
    add_column :users, :first_name, :string
    add_column :users, :middle_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address_line_1, :string
    add_column :users, :address_line_2, :string
    add_column :users, :city, :string
    add_column :users, :state_cd, :string
    add_column :users, :zip_cd, :string
    add_column :users, :profile_url, :string
    add_column :users, :profile_headline, :string
    add_column :users, :industry_id, :integer
  end
end
