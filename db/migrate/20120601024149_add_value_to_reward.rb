class AddValueToReward < ActiveRecord::Migration
  def change
    add_column :rewards, :value, :decimal, :precision => 8, :scale => 2
  end
end
