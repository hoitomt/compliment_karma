class DropColumnsFromRewards < ActiveRecord::Migration
  def up
  	remove_column :rewards, :name
  	remove_column :rewards, :image_thumb
  	remove_column :rewards, :image_mini
  end

  def down
  	add_column :rewards, :name, :string
  	add_column :rewards, :image_thumb, :string
  	add_column :rewards, :image_mini, :string
  end
end
