class CreateRelationshipStatuses < ActiveRecord::Migration
  def change
    create_table :relationship_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
