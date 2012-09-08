class AddDefaultGroupsForUsers < ActiveRecord::Migration
  def up
		GroupType.create(:name => "Professional")
		GroupType.create(:name => "Social")
		GroupType.create(:name => "Declined")
		
  	TaskRunner.create_groups_and_migrate
  	TaskRunner.add_users_to_redis
  end

  def down
  end
end
