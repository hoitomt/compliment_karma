class AddSortOrderToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :sort_order, :integer
  end
end
