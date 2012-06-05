class AddDefaultVisibilityToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :default_visibility_id, :integer
  end
end
