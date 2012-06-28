class CreateCompanyAdministrators < ActiveRecord::Migration
  def change
    create_table :company_administrators do |t|
      t.integer :company_id
      t.integer :user_id

      t.timestamps
    end
  end
end
