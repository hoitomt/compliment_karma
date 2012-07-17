class AddLastReadNotificationDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_read_notification_date, :datetime
  end
end
