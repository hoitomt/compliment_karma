class AddComplimentTypeToCompliments < ActiveRecord::Migration
  def change
    add_column :compliments, :compliment_type, :integer
    remove_column :compliments, :compliment_sent_status
  end
end
