class AddOriginatingUserIdToUpdateHistories < ActiveRecord::Migration
  def change
    add_column :update_histories, :originating_user_id, :integer
  end
end
