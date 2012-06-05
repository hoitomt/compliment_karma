class AddSentStatusIdToCompliment < ActiveRecord::Migration
  def change
    add_column :compliments, :compliment_sent_status, :string
  end
end
