class RenameDisplayToDisplayInd < ActiveRecord::Migration
  def up
  	rename_column :groups, :display, :display_ind
  end

  def down
  	rename_column :groups, :display_ind, :display
  end
end
