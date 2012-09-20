class AddDisplayIndicatorToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :display, :string, :default => "N"
  end
end
