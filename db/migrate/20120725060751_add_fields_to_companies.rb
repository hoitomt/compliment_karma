class AddFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :industry, :string
    add_column :companies, :company_type, :string
    add_column :companies, :company_size, :string
    add_column :companies, :operating_status, :string
    add_column :companies, :year_founded, :integer
    add_column :companies, :description, :text
  end
end
