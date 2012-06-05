class AddComplimentStatusToCompliments < ActiveRecord::Migration
  def change
    add_column :compliments, :compliment_status_id, :integer
  end
end
