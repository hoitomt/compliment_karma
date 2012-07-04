class DropUserRewardsTable < ActiveRecord::Migration
  def up
  	drop_table :user_rewards
  end

  def down
  	create_table :user_rewards do |t|
      t.integer :user_id
      t.integer :reward_id

      t.timestamps
    end
  end
end
