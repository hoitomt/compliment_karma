class AddManagerToCompanyDepartments < ActiveRecord::Migration
  def change
    add_column :company_departments, :manager, :string
  end
end
