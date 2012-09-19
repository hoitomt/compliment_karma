class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :recognition_id
      t.integer :recognition_type_id
      t.integer :group_id

      t.timestamps
    end
  end
end
