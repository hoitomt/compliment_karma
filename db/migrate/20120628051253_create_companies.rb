class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address_line_1
      t.string :address_line_2
      t.string :address_line_3
      t.string :city
      t.string :state_cd
      t.string :zip_cd
      t.string :country
      t.string :email
      t.string :url
      t.string :phone

      t.timestamps
    end
  end
end
