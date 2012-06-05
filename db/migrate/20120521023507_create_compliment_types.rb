class CreateComplimentTypes < ActiveRecord::Migration
  def change
    create_table :compliment_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
