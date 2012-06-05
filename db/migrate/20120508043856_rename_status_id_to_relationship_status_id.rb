class RenameStatusIdToRelationshipStatusId < ActiveRecord::Migration
  def up
    rename_column :relationships, :status_id, :relationship_status_id 
  end

  def down
    rename_column :relationships, :relationship_status_id, :status_id
  end
end
