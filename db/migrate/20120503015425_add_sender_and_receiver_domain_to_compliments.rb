class AddSenderAndReceiverDomainToCompliments < ActiveRecord::Migration
  def change
    add_column :compliments, :sender_domain, :string
    add_column :compliments, :receiver_domain, :string
  end
end
