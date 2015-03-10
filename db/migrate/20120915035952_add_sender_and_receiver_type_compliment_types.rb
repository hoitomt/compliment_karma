class AddSenderAndReceiverTypeComplimentTypes < ActiveRecord::Migration
  def up
  	add_column :compliment_types, :sender_type, :string
  	add_column :compliment_types, :receiver_type, :string
  end

  def down
  	remove_column :compliment_types, :sender_type
  	remove_column :compliment_types, :receiver_type
  end
end
