class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :cc_holder_name
      t.string :cc_number
      t.string :cc_cvv
      t.string :cc_expiration_month
      t.string :cc_expiration_year
      t.string :cc_billing_address
      t.string :cc_billing_city
      t.string :cc_billing_state_cd
      t.string :cc_billing_zip_cd
      t.string :cc_card_type
      t.string :amount
      t.string :payment_type

      t.timestamps
    end
  end
end
