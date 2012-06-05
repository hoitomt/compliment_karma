class AddTypeToUpdateHistory < ActiveRecord::Migration
  def change
    add_column :update_histories, :update_history_type_id, :integer
    add_column :update_histories, :recognition_type_id, :integer
    add_column :update_histories, :recognition_id, :integer
  end
end
