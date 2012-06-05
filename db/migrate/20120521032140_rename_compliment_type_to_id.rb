class RenameComplimentTypeToId < ActiveRecord::Migration
  def up
    rename_column :compliments, :compliment_type, :compliment_type_id
  end

  def down
    rename_column :compliments, :compliment_type_id, :compliment_type
  end
end
