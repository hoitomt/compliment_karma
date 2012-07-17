class AddReadStatusToUpdateHistory < ActiveRecord::Migration
  def change
    add_column :update_histories, :read, :string
  end
end
