class CreateComplimentStatuses < ActiveRecord::Migration
  def change
    create_table :compliment_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
