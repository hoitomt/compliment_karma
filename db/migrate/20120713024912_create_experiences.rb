class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :company
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.text :responsibilities
      t.string :city
      t.string :state_cd
      t.integer :user_id

      t.timestamps
    end
  end
end
