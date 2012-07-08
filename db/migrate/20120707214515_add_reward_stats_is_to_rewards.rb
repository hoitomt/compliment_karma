class AddRewardStatsIsToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :reward_status_id, :integer
  end
end
