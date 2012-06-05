class AddVisibilityIdToCompliments < ActiveRecord::Migration
  def change
    add_column :compliments, :visibility_id, :integer
  end
end
