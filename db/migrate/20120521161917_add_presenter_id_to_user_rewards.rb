class AddPresenterIdToUserRewards < ActiveRecord::Migration
  def change
    add_column :user_rewards, :presenter_id, :integer
  end
end
