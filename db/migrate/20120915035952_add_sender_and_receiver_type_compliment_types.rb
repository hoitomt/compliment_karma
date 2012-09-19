class AddSenderAndReceiverTypeComplimentTypes < ActiveRecord::Migration
  def up
  	add_column :compliment_types, :sender_type, :string
  	add_column :compliment_types, :receiver_type, :string

  	c = ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
  	c.update_attributes(:sender_type => 'Professional', :receiver_type => 'Professional')
  	c = ComplimentType.PROFESSIONAL_TO_PERSONAL
  	c.update_attributes(:sender_type => 'Professional', :receiver_type => 'Social')
  	c = ComplimentType.PERSONAL_TO_PROFESSIONAL
  	c.update_attributes(:sender_type => 'Social', :receiver_type => 'Professional')
  	c = ComplimentType.PERSONAL_TO_PERSONAL
  	c.update_attributes(:sender_type => 'Social', :receiver_type => 'Social')
  end

  def down
  	remove_column :compliment_types, :sender_type
  	remove_column :compliment_types, :receiver_type
  end
end
