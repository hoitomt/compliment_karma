class AddUserIdToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :receiver_id, :integer
    add_column :rewards, :presenter_id, :integer
  end
end
