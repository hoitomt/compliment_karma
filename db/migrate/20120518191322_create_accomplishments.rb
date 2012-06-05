class CreateAccomplishments < ActiveRecord::Migration
  def change
    create_table :accomplishments do |t|
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
