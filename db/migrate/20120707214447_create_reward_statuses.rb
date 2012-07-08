class CreateRewardStatuses < ActiveRecord::Migration
  def change
    create_table :reward_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
