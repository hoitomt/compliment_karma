class CreateUpdateHistoryTypes < ActiveRecord::Migration
  def change
    create_table :update_history_types do |t|
      t.string :name
      t.string :text

      t.timestamps
    end
  end
end
