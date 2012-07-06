class CreateCompanyDepartmentUsers < ActiveRecord::Migration
  def change
    create_table :company_department_users do |t|
      t.integer :user_id
      t.integer :company_department_id

      t.timestamps
    end
  end
end
