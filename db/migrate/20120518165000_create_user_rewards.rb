class CreateUserRewards < ActiveRecord::Migration
  def change
    create_table :user_rewards do |t|
      t.integer :user_id
      t.integer :reward_id

      t.timestamps
    end
  end
end
